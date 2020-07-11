require_relative "questions_database"
require_relative "user"

class Reply
	attr_accessor :body, :user_id, :question_id, :parent_reply_id

	def self.find_by_id(id)
		datum = QuestionsDatabase.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				replies
			WHERE
				id = ?
		SQL
		raise "no reply found" if datum.empty?
		Reply.new(datum[0])
	end

	def self.find_by_user_id(user_id)
		data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
			SELECT
				*
			FROM
				replies
			WHERE
				user_id = ?
		SQL
		raise "no replies found" if data.empty?
		data.map { |datum| Reply.new(datum) }
	end

	def self.find_by_question_id(question_id)
		data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
			SELECT
				*
			FROM
				replies
			WHERE
				question_id = ?
		SQL
		raise "no replies found" if data.empty?
		data.map { |datum| Reply.new(datum) }
	end

	def initialize(options)
		@id = options['id']
		@body = options['body']
		@user_id = options['user_id']
		@question_id = options['question_id']
		@parent_reply_id = options['parent_reply_id']
	end

	def author
		author = QuestionsDatabase.instance.execute(<<-SQL, @id)
			SELECT 
				users.id, users.fname, users.lname
			FROM 
				replies 
			JOIN 
				users ON users.id = replies.user_id
			WHERE
				replies.id = ?
		SQL
		User.new(author[0])
	end

	def question
		question = QuestionsDatabase.instance.execute(<<-SQL, @id)
			SELECT 
				questions.id, questions.title, questions.body, questions.author_id
			FROM 
				questions 
			JOIN 
				replies ON replies.question_id = questions.id
			WHERE
				replies.id = ?
		SQL
		Question.new(question[0])
	end

	def parent_reply
		raise "no parent reply found" unless parent_reply_id
		parent_reply = QuestionsDatabase.instance.execute(<<-SQL, parent_reply_id)
			SELECT 
				replies.id, replies.body, replies.user_id, replies.question_id 
			FROM 
				replies
			WHERE
				replies.id = ?
		SQL
		Reply.new(parent_reply[0])
	end

	def child_replies
		child_replies = QuestionsDatabase.instance.execute(<<-SQL, @id)
			SELECT 
				replies.id, replies.body, replies.user_id, replies.question_id, replies.parent_reply_id
			FROM 
				replies
			WHERE
				replies.parent_reply_id = ?
		SQL
		raise "no replies found" if child_replies.empty?
		child_replies.map { |child_reply| Reply.new(child_reply) }
	end

	def save
		if @id
			QuestionsDatabase.instance.execute(<<-SQL, @body, @user_id, @question_id, @parent_reply_id, @id)
				UPDATE
					replies
				SET
					body = ?,
					user_id = ?,
					question_id = ?,
					parent_reply_id = ?
				WHERE
					id = ?
			SQL
		else
			QuestionsDatabase.instance.execute(<<-SQL, @body, @user_id, @question_id, @parent_reply_id)
				INSERT INTO
					replies (body, user_id, question_id, parent_reply_id)
				VALUES
					(?, ?, ?, ?)
			SQL
			@id = QuestionsDatabase.instance.last_insert_row_id
		end
	end
end