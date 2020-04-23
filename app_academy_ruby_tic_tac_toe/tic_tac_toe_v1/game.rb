require_relative 'board.rb'
require_relative 'human_player.rb'

class Game
	def initialize(player_1_mark, player_2_mark)
		@player_1 = HumanPlayer.new(player_1_mark)
		@player_2 = HumanPlayer.new(player_2_mark)
		@board = Board.new
		@current_player = @player_1
	end

	def switch_turn
		@current_player == @player_1 ? @current_player = @player_2 : @current_player = @player_1
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