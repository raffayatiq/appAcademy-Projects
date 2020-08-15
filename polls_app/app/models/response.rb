class Response < ApplicationRecord
	validate :not_duplicate_response
	validate :respondent_is_not_poll_author

	belongs_to :answer_choice,
		class_name: :AnswerChoice,
		foreign_key: :answer_choice_id,
		primary_key: :id

	belongs_to :respondent,
		class_name: :User,
		foreign_key: :respondent_id,
		primary_key: :id

	has_one :question,
		through: :answer_choice,
		source: :question

	has_one :poll,
		through: :question,
		source: :poll

	after_destroy :log_destroy_action

	def sibling_responses
		self.question.responses.where.not(id: self.id)
	end

	def respondent_already_answered?
		sibling_responses.exists?(respondent_id: self.respondent_id)
	end

	def not_duplicate_response
		if respondent_already_answered?
			errors[:respondent] << "cannot vote twice for the same question."
		end
	end

	def author_answering?
		self.poll.author_id == self.respondent_id
	end

	def respondent_is_not_poll_author
		if author_answering?
			errors[:author] << "cannot answer his own poll."
		end
	end

	def log_destroy_action
		puts "Responses destroyed"
	end
end