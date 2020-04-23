class HumanPlayer
	attr_reader :mark

	def initialize(mark_value)
		@mark = mark_value
	end

	def get_position(legal_positions)
		puts "Player #{@mark}, enter two numbers representing a position in the format `row col`"
		position = nil
		while !legal_positions.include?(position)
			position = gets.chomp.split(" ")
			position = position.map { |ele| ele.to_i }
			if !legal_positions.include?(position)
				puts "#{position} is not a legal position"
			end
		end
		return position
	end
end