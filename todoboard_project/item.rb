class Item
	attr_reader :deadline, :done
	attr_accessor :title, :description

	def self.valid_date?(date_string)
		date_array = date_string.split('-')
		month = date_array[1].to_i
		day = date_array[2].to_i
		return false if month > 12 || month < 1
		return false if day > 31 || day < 1
		return true
	end

	def initialize(title, deadline, description)
		raise 'invalid deadline' if !Item::valid_date?(deadline)
		@title = title
		@deadline = deadline
		@description = description
		@done = false
	end

	def deadline=(deadline)
		raise 'invalid deadline' if !Item::valid_date?(deadline)
		@deadline = deadline
	end

	def toggle
		@done = !@done
	end
end