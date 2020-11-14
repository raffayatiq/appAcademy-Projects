class Session < ApplicationRecord
	validates :session_token, presence: true
	validates :session_token, uniqueness: true

	belongs_to :user

	def self.generate_session_token
		SecureRandom::urlsafe_base64(16)
	end

	def reset_session_token!
		self.session_token = self.class.generate_session_token
		self.save!
		self.session_token
	end
end