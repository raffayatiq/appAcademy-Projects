require_relative "questions_database"
require_relative "user"

class QuestionFollow
	def self.followers_for_question_id(question_id)
		followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
			SELECT
				users.id, users.fname, users.lname
			FROM
				question_follows
			JOIN
				users ON users.id = question_follows.user_id
			WHERE
				question_follows.question_id = ?
		SQL
		raise "no followers found" if followers.empty?
		followers.map { |follower| User.new(follower) }
	end

	def self.followed_questions_for_user_id(user_id)
		questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
			SELECT 
				questions.id, questions.title, questions.body, questions.author_id
			FROM 
				questions 
			JOIN 
				question_follows ON question_follows.question_id = questions.id
			WHERE
				question_follows.user_id = ?
		SQL
		raise "no questions found" if questions.empty?
		questions.map { |question| Question.new(question) }
	end

	def self.most_followed_questions(n)
		questions = QuestionsDatabase.instance.execute(<<-SQL, n)
			SELECT 
				COUNT(id) AS num, questions.id
			FROM 
				questions 
			LEFT JOIN 
				question_follows ON question_follows.question_id = questions.id 
			GROUP BY 
				questions.id
			ORDER BY
				num DESC
			LIMIT
				?
		SQL
		
		raise "total most followed questions are less than what was asked" if questions.size < n
		
		questions.map do |question|
			question_id = question['id']
			Question::find_by_id(question_id)
		end
	end
end