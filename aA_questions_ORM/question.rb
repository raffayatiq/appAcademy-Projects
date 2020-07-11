require_relative "questions_database"
require_relative "user"
require_relative "reply"
require_relative "question_follow"
require_relative "question_like"

class Question
	attr_accessor :title, :body, :author_id

	def self.find_by_id(id)
		datum = QuestionsDatabase.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				questions
			WHERE
				id = ?
		SQL
		raise "no question found" if datum.empty?
		Question.new(datum[0])
	end

	def self.find_by_author_id(author_id)
		data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
			SELECT
				*
			FROM
				questions
			WHERE
				id = ?
		SQL
		raise "no questions found" if data.empty?
		data.map { |datum| Question.new(datum) }
	end

	def self.most_followed(n)
		QuestionFollow::most_followed_questions(n)		
	end

	def self.most_liked(n)
		QuestionLike::most_liked_questions(n)
	end

	def initialize(options)
		@id = options['id']
		@title = options['title']
		@body = options['body']
		@author_id = options['author_id']
	end

	def author
		author = QuestionsDatabase.instance.execute(<<-SQL, @id, author_id)
			SELECT
				users.id, users.fname, users.lname
			FROM
				users
			JOIN
				questions ON questions.author_id = users.id
			WHERE
				questions.id = ?
					AND questions.author_id = ?		
		SQL
		User.new(author[0])
	end

	def replies
		replies = QuestionsDatabase.instance.execute(<<-SQL, @id)
			SELECT
				replies.id, replies.body, replies.user_id, replies.question_id, replies.parent_reply_id
			FROM 
				replies 
			JOIN 
				questions ON replies.question_id = questions.id 
			WHERE 
				questions.id = ?;
		SQL
		replies.map { |reply| Reply.new(reply) }
	end

	def followers
		QuestionFollow::followers_for_question_id(@id)
	end

	def likers
		QuestionLike::likers_for_question_id(@id)
	end

	def num_likes
		QuestionLike::num_likes_for_question_id(@id)
	end

	def save
		if @id
			QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @author_id, @id)
				UPDATE
					questions
				SET
					title = ?,
					body = ?,
					author_id = ?
				WHERE
					id = ?
			SQL
		else
			QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @author_id)
				INSERT INTO
					questions (title, body, author_id)
				VALUES
					(?, ?, ?)
			SQL
			@id = QuestionsDatabase.instance.last_insert_row_id
		end
	end
end