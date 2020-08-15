class Poll < ApplicationRecord
	validates :title, presence: true

	belongs_to :author,
		class_name: :User,
		foreign_key: :author_id,
		primary_key: :id

	has_many :questions,
		class_name: :Question,
		foreign_key: :poll_id,
		primary_key: :id

	after_destroy :log_destroy_action

	def log_destroy_action
		puts "Polls destroyed"
	end
end