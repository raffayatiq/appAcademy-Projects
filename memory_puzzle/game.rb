require_relative 'board.rb'
require_relative 'player.rb'
require_relative 'computerplayer.rb'

class Game
	def initialize(*players)
		@board = Board.new
		@first_guess = nil
		@second_guess = nil
		@players = players
		@current_player = @players[0]
		players.each { |player| player.get_board_size(@board.size) }
	end

	def play
		while !@board.won?
			@board.render
			sleep(0.5)
			puts "Player #{@current_player.name}'s turn!"
			puts "Please enter the position of the card you'd like to flip (e.g., '2,3')"
			guess = @current_player.prompt

			next if !@board.is_valid_guess?(guess)
			
			take_turn(guess)
		end

		winner = self.get_winner
		puts "Player #{winner.name} has won!!!"
	end

	def switch_turn
		@players.rotate!
		@current_player = @players[0]
	end

	def take_turn(guess)
		if @first_guess == nil
			make_first_guess(guess)
		else
			@board.reveal(guess)
			@board.render
			@second_guess = guess
			make_second_guess(guess)
			@second_guess, @first_guess = nil, nil
		end
	end

	def get_winner
		sorted_players = @players.sort_by { |player| player.score }
		sorted_players[-1]
	end

	private
	def make_first_guess(guess)
		@board.reveal(guess)
		@first_guess = guess
		card = @board[@first_guess]
		@players.each { |player| player.receive_revealed_card(@first_guess, card.face) }
	end

	def make_second_guess(guess)
		if @board.is_match?(@second_guess, @first_guess)
			puts "It's a match!"
			@current_player.increase_score
			@players.each { |player| player.receive_match(@second_guess, @first_guess) }
			sleep(1.2)
		else !@board.is_match?(@second_guess, @first_guess)
			puts "Try again."
			sleep(1.2)
			@board.hide_cards(@second_guess, @first_guess)
			self.switch_turn
		end
		card = @board[@second_guess]
		@players.each { |player| player.receive_revealed_card(@second_guess, card.face) }	
	end
end