require_relative 'player.rb'
require_relative 'hand.rb'
require_relative 'deck.rb'

class Game
	attr_reader :players, :pot, :deck, :currentbet, :any_fold

	def initialize
		@players = [Player.new("1"), Player.new("2"), Player.new("3"), Player.new("4")]
		@pot = 0
		@deck = Deck.new
		@currentbet = 0
		@any_fold = false # to track whether a single player has folded or not
		deck.shuffle
		deal_in_players
	end

	def current_player
		players[0]
	end

	def deal_in_players
		@players.each do |player|
			hand = Hand.new(deck.take_cards(5))
			player.deal_in(hand)
		end
	end

	def switch_player
		@players.rotate!
	end

	def reset_deck_hands_and_players
		@deck = Deck.new
		deck.shuffle
		switch_player until current_player.name == "1"
		unfold_players
		deal_in_players
	end

	def render
		puts ("Player " + "1").rjust(15)
		puts "____".rjust(13)
		print "Player"
		print ("| " + "$" + pot.to_s + " |").rjust(8)
		puts "Player".rjust(8)
		print "2".rjust(4)
		print "|____|".rjust(10)
		puts "3".rjust(6)
		puts ("Player " + "4").rjust(15)
	end

	def showdown
		winning_player = nil

		return unfolded_players[0] if unfolded_players.length == 1

		(unfolded_players.length-1).times do |i|
			case (unfolded_players[i].hand <=> unfolded_players[i + 1].hand)
			when 1
				if winning_player
					next if (winning_player.hand <=> unfolded_players[i].hand) == 1
				end
				winning_player = unfold_players[i]
			when -1
				if winning_player
						next if (winning_player.hand <=> unfolded_players[i + 1].hand) == 1
				end
					winning_player = unfolded_players[i + 1]
			end
		end
		winning_player
	end

	def play
		until over?
			finish_round if unfolded_players.length <= 0
			take_player_turns
			if any_fold
				finish_round if unfolded_players.length <= 1
				ask_players_to_trade
			else
				finish_round
			end
			@any_fold = false
		end
		puts "Player #{winner.name} is the winner!"
	end

	private
	attr_writer :pot

	def unfolded_players
		players.select { |player| !player.folded }
	end

	def unfold_players
		players.each { |player| player.unfold if player.pot != 0 }
	end

	def over?
		players.count { |player| player.pot == 0 } == 3
	end

	def winner
		players.each { |player| return player if player.pot != 0}
	end

	def last_player
		#We must countdown from 4 because #switch_player implementation forces us to do so
		(1..4).to_a.reverse_each do |num|
			debugger
			players.each { |player| return player if player.name == num.to_s && !player.folded}
		end
	end

	def display
		system("cls")
		render
	end

	def take_turn
		puts "Player #{current_player.name}'s turn!"
			current_player.show_hand
			current_player.show_pot
			case current_player.choice
			when 'f'
				current_player.fold
				@any_fold = true
			when 's'
				if currentbet == 0
					puts "You must raise for the opening bet..."
					sleep(1)
					display
					take_turn
				end
				@pot += current_player.call(currentbet)
			when 'r'
				player_raise = current_player.raise_bet(currentbet)
				@pot += player_raise
				@currentbet = player_raise
			else
				puts "Enter valid input..."
				sleep(1)
				display
				take_turn
			end
	end

	def ask_players_to_trade
		unfolded_players.each do |player| 
			display
			player.hand.trade_cards(player.cards_to_discard, deck)
		end
	end

	def finish_round
		round_winner = showdown
		if round_winner == nil || players.all? { |player| player.folded }
			puts "No winner..."
			sleep(1)
		else
			round_winner.pot += pot
			@pot = 0
			@currentbet = 0
			unfold_players
			puts "Player #{round_winner.name} has won the round!"
			sleep(1)
		end
		reset_deck_hands_and_players
	end

	def take_player_turns
		4.times do 
				if current_player.folded
					switch_player
					next
				end
				begin
				display
				take_turn
				switch_player
				rescue ArgumentError => e
					puts e
					sleep(1)
					display
					retry
				end
			end
	end
end

if $PROGRAM_NAME == __FILE__
	game = Game.new
	game.play
end
