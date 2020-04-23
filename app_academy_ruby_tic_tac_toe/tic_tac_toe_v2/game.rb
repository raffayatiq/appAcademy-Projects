require_relative 'board.rb'
require_relative 'human_player.rb'

class Game
	def initialize(board_size, *mark_values)
		@players = mark_values.map { |mark| HumanPlayer.new(mark) }
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
			begin
				position = @current_player.get_position
				@board.place_mark(position, @current_player.mark)
			rescue
				puts "Invalid position."
				self.play
			end

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