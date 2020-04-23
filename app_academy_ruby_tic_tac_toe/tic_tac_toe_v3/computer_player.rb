class ComputerPlayer
	attr_reader :mark

	def initialize(mark_value)
		@mark = mark_value
	end

	def get_position(legal_positions)
		position = legal_positions[rand(0...legal_positions.length)]
		puts "Computer #{@mark} chose #{position[0]} #{position[1]}"
		return position
	end
end