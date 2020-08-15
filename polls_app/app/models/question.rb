class Question < ApplicationRecord
	validates :text, presence: true

	has_many :answer_choices,
		class_name: :AnswerChoice,
		foreign_key: :question_id,
		primary_key: :id

	belongs_to :poll,
		class_name: :Poll,
		foreign_key: :poll_id,
		primary_key: :id

	has_many :responses,
		through: :answer_choices,
		source: :responses

	after_destroy :log_destroy_action

	def results
		results = {}
		
		answer_choices_with_response_count = 
		AnswerChoice
			.left_joins(:responses)
			.select('answer_choices.*, COUNT(responses.*) as response_count')
			.group('answer_choices.id')
			.where(answer_choices: { question_id: self.id })
		
		answer_choices_with_response_count.each do |element|
			results[element.text] = element.response_count
		end

		results
	end

	def log_destroy_action
		puts "Questions destroyed"
	end
end