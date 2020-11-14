class User < ApplicationRecord
	attr_reader :password

	validates :username, presence: true
	validates :password_digest, presence: { message: "Password can\'t be blank."}
	validates :password, length: { minimum: 6 }, allow_nil: true

	has_many :cats

	has_many :cat_rental_requests,
		class_name: :CatRentalRequest,
		foreign_key: :requester_id,
		primary_key: :id

	has_many :sessions

	def self.find_by_credentials(username, password)
		user = User.find_by(username: username)
		return nil if user.nil?
		user.is_password?(password) ? user : nil
	end

	def reset_session!(session_token)
		session = Session.find_by(session_token: session_token)
		session.reset_session_token!
	end

	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

	def is_password?(password)
		BCrypt::Password.new(self.password_digest).is_password?(password)
	end
end
