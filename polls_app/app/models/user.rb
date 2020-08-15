class User < ApplicationRecord
	validates :username, presence: true, uniqueness: true

	has_many :authored_polls,
		class_name: :Poll,
		foreign_key: :author_id,
		primary_key: :id,
		dependent: :destroy

	has_many :responses,
		class_name: :Response,
		foreign_key: :respondent_id,
		primary_key: :id,
		dependent: :destroy
end