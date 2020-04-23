require_relative "board"
require_relative "player"

class Battleship
	attr_reader :board, :player

	def initialize(n)
		@player = Player.new
		@board = Board::new(n)
		@remaining_misses = @board.size / 2
	end

	def start_game
		board.place_random_ships
		puts board.grid.flatten.count(:S)
		board.print
	end

	def lose?
		if @remaining_misses <= 0
			puts "You lose."
			true
		else
			false
		end
	end

	def win?
		if board.num_ships == 0
			puts "You win."
			true
		else
			false
		end
	end

	def game_over?
		self.win? || self.lose?
	end

	def turn
		move = @player.get_move
		@remaining_misses -= 1 if !board.attack(move)
		board.print
		print "Remaining misses: "
		puts @remaining_misses

	end
end
