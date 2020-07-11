require_relative "questions_database"
require_relative "question"
require_relative "user"
require_relative "question_follow"
require_relative "question_like"

class User
	attr_accessor :fname, :lname

	def self.find_by_id(id)
		datum = QuestionsDatabase.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				users
			WHERE
				id = ?
		SQL
		raise "no user found" if datum.empty?
		User.new(datum[0])
	end

	def self.find_by_name(fname, lname)
		datum = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
			SELECT
				*
			FROM
				users
			WHERE
				fname = ?
					AND lname = ?
		SQL
		raise "no user found" if datum.empty?
		User.new(datum[0])
	end

	def initialize(options)
		@id = options['id']
		@fname = options['fname']
		@lname = options['lname']
	end

	def authored_questions
		Question::find_by_author_id(@id)
	end

	def authored_replies
		Reply::find_by_user_id(@id)
	end

	def followed_questions
		QuestionFollow::followed_questions_for_user_id(@id)
	end

	def liked_questions
		QuestionLike::liked_questions_for_user_id(@id)
	end

	def average_karma
		datum = QuestionsDatabase.instance.execute(<<-SQL, @id)
			SELECT
				COALESCE((total_likes / CAST(total_questions AS FLOAT)), 0) AS average_karma
			FROM (
				SELECT 
					COUNT(DISTINCT questions.id) AS total_questions, COUNT(DISTINCT question_likes.user_id) AS total_likes
				FROM 
					questions 
				LEFT JOIN 
					question_likes ON question_likes.question_id = questions.id 
				JOIN 
					users ON users.id = questions.author_id 
				WHERE 
					users.id = ?
			)
		SQL
		datum[0]['average_karma']
	end

	def save
		if @id
			QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
				UPDATE
					users
				SET
					fname = ?,
					lname = ?
				WHERE
					id = ?
			SQL
		else
			QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
				INSERT INTO
					users (fname, lname)
				VALUES
					(?, ?)
			SQL
			@id = QuestionsDatabase.instance.last_insert_row_id
		end
	end
end