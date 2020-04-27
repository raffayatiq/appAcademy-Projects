require_relative 'board.rb'
require_relative 'human_player.rb'

class Game
	def initialize(board_size, hash)
		marks = hash.keys
		booleans = hash.values
		@players = marks.map { |key| hash[key] ? ComputerPlayer.new(key) : HumanPlayer.new(key) }
		@board = Board.new(board_size)
		@current_player = @players[0]
	end

	def switch_turn
		@players.rotate!
		@current_player = @players[0]
	end

	def play
		while @board.empty_positions?
			@board.print
			position = @current_player.get_position(@board.legal_positions)
			@board.place_mark(position, @current_player.mark)

			if @board.win?(@current_player.mark)
				puts "#{@current_player.mark} has won the game!"
				return
			else
				self.switch_turn
			end
		end
		puts "Draw."
	end
end