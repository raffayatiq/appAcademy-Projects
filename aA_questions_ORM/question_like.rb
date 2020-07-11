require_relative "questions_database"
require_relative "user"
require_relative "question"

class QuestionLike
	def self.likers_for_question_id(question_id)
		likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
			SELECT
				users.id, users.fname, users.lname
			FROM
				question_likes
			JOIN
				users ON users.id = question_likes.user_id
			WHERE
				question_likes.question_id = ?
		SQL
		raise "no likers found" if likers.empty?
		likers.map { |liker| User.new(liker) }
	end

	def self.num_likes_for_question_id(question_id)
		likes = QuestionsDatabase.instance.execute(<<-SQL, question_id)
			SELECT
				COUNT(DISTINCT user_id) AS num
			FROM
				question_likes
			WHERE
				question_likes.question_id = ?
		SQL
		likes[0]['num']
	end

	def self.liked_questions_for_user_id(user_id)
		questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
			SELECT 
				questions.id, questions.title, questions.body, questions.author_id
			FROM 
				question_likes 
			JOIN 
				questions ON questions.id = question_likes.question_id 
			WHERE 
				user_id = ?
		SQL
		raise "no questions found" if questions.empty?
		questions.map { |question| Question.new(question) }
	end

	def self.most_liked_questions(n)
		questions = QuestionsDatabase.instance.execute(<<-SQL, n)
			SELECT 
				questions.id, questions.title, questions.body, questions.author_id, COUNT(DISTINCT user_id) AS num 
			FROM 
				questions 
			LEFT JOIN 
				question_likes ON question_likes.question_id = questions.id 
			GROUP BY 
				question_id 
			ORDER BY 
				num DESC
			LIMIT
				?
		SQL
		raise "total most liked questions fewer than what was asked" if questions.size < n
		questions.map { |question| Question.new(question) }
	end
end