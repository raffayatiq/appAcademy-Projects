require 'byebug'
require 'colorize'

class Tile
	attr_reader :adjacent_bombs, :neighbours

	def initialize
		@adjacent_bombs = 0
		@bombed = false
		@flagged = false
		@revealed = false
		@neighbours = []
	end

	def reveal
		@revealed = true
	end

	def revealed?
		revealed
	end

	def bomb
		@bombed = true
	end

	def bombed?
		bombed
	end

	def flag
		@flagged = !@flagged
	end

	def flagged?
		flagged
	end

	def to_s
		if self.flagged?
			"F"
		elsif !self.revealed?
			"*"
		elsif self.bombed? && self.revealed?
			"B".colorize(:red)
		else
			adjacent_bombs == 0 ? "_" : adjacent_bombs.to_s
		end
	end

	def get_neighbours(board, pos)
		neighbour_positions = get_neighbour_positions(pos)
		neighbour_positions.each do |position|
			@neighbours << board[position]
		end
	end

	def set_neighbour_bomb_count(board, pos)
		get_neighbours(board, pos)
		neighbours.each { |neighbour| @adjacent_bombs += 1 if neighbour.bombed?}
	end

	def inspect
		"#{@adjacent_bombs} "
	end

	private
	attr_reader :revealed, :bombed, :flagged
	attr_writer :adjacent_bombs

	def get_neighbour_positions(pos)
		positions = 
		[
			[pos[0] - 1, pos[1]],
			[pos[0] - 1, pos[1] + 1],
			[pos[0], pos[1] + 1],
			[pos[0] + 1, pos[1] + 1],
			[pos[0] + 1, pos[1]],
			[pos[0] + 1, pos[1] - 1],
			[pos[0], pos[1] - 1],
			[pos[0] - 1, pos[1] - 1]
		]
		positions = positions.select do |position|
			position.all? { |ele| ele <= 8 && ele >= 0 }
		end
	end

end