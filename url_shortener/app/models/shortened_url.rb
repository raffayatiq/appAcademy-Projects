class ShortenedUrl < ApplicationRecord
	validates :long_url, :short_url, :user_id, presence: true
	validates :short_url, uniqueness: true
	validate :no_spamming
	validate :nonpremium_max

	belongs_to :submitter,
		class_name: :User,
		foreign_key: :user_id,
		primary_key: :id

	has_many :visits,
		class_name: :Visit,
		foreign_key: :shortened_url_id,
		primary_key: :id

	has_many :visitors,
		-> { distinct },
		through: :visits,
		source: :visitor

	has_many :taggings,
		class_name: :Tagging,
		foreign_key: :shortened_url_id,
		primary_key: :id

	has_many :tag_topics,
		through: :taggings,
		source: :tag_topic

	def self.random_code
		code = SecureRandom::urlsafe_base64
		while ShortenedUrl.exists? :short_url => code
			code = SecureRandom::urlsafe_base64
		end
		code
	end

	def self.create_for_user_and_long_url!(user, long_url)
		ShortenedUrl.create!(
			short_url: ShortenedUrl::random_code,
			long_url: long_url,
			user_id: user.id
		)
	end

	def self.prune(n)
		deleted_urls =
		ShortenedUrl
			.joins('INNER JOIN users ON users.id = shortened_urls.user_id')
			.joins('LEFT JOIN visits ON visits.shortened_url_id = shortened_urls.id')
			.where('(visits.created_at < ? OR shortened_urls.id IN
				(
					SELECT 
						shortened_urls.id
					FROM
						shortened_urls
					LEFT JOIN
						visits ON visits.shortened_url_id = shortened_urls.id
					WHERE
						shortened_urls.created_at < ? AND visits.id IS NULL
				)
				) AND users.premium = false', n.minutes.ago, n.minutes.ago)
			.destroy_all
		
		deleted_urls.each do |deleted_url|
			until deleted_url.visits.nil?
				deleted_url.visits.destroy(Visit.find_by({ shortened_url_id: deleted_url.id }))
			end
		end

		deleted_urls.each do |deleted_url|
			until deleted_url.taggings.nil?
				deleted_url.taggings.destroy(Tagging.find_by({ shortened_url_id: deleted_url.id }))
			end
		end
	end

	def num_clicks
		self.visits.count
	end

  def num_uniques
  	self.visitors.count
  end

	def num_recent_uniques
		visits
			.select('user_id')
			.where('created_at > ?', 10.minutes.ago)
			.distinct
			.count
	end

	def no_spamming
		url_count_in_a_minute = ShortenedUrl
		.where('created_at >= ?', 1.minute.ago)
		.where(user_id: user_id)
		.length

		if url_count_in_a_minute > 5
			errors[:base] << "More than 5 URLs are being submitted in a single minute. Please wait and try again."
		end
	end

	def nonpremium_max
		return if User.find(user_id).premium

		total_submitted = ShortenedUrl
		.where(user_id: user_id)
		.count

		errors[:base] << "Non-premium users cannot submit more than 5 URLs. Upgrade your membership. " if total_submitted > 5
	end
end