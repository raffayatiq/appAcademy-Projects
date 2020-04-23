class HumanPlayer
	attr_reader :mark

	def initialize(mark_value)
		@mark = mark_value
	end

	def get_position
		print "Enter position(row col): "
		position = gets.chomp.split(" ")
		numbers = ("0".."9").to_a
		raise "invalid position" if position.any? { |ele| !numbers.include?(ele) } || position.length != 2
		position = position.map { |ele| ele.to_i }
		return position
	end
end