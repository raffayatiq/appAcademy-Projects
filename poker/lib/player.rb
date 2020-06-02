require_relative 'hand'
require_relative 'deck'

class Player
	attr_reader :name, :hand, :folded
	attr_accessor :pot

	def initialize(name, pot = 25)
		@name = name
		@pot = pot
		@folded = false
	end

	def deal_in(hand)
		raise ArgumentError.new("invalid hand size") if hand.cards.length < 5
		@hand = hand
	end

	def choice
		print "(f)old, (s)ee, or (r)aise > "
		gets.chomp
	end

	def fold
		@folded = true
	end

	def unfold
		@folded = false
	end

	def call(current_bet)
		raise ArgumentError.new("insufficient pot") if current_bet > pot
		@pot -= current_bet
		current_bet
	end

	def raise_bet(current_bet)
		print "Enter amount to raise > "
		input = gets.chomp.to_i
		raise ArgumentError.new("bet must be higher than current_bet") if input <= current_bet
		raise ArgumentError.new("insufficient pot") if input > pot
		@pot -= input
		input
	end

	def show_hand
		print "Player #{self.name}: " 
		puts self.hand.cards.join(" ")
	end

	def show_pot
		print "Player #{self.name}'s pot : " 
		puts "$#{self.pot}"
	end

	def cards_to_discard
		indices = []
		while true
			puts "Choose cards to discard (enter 'q' to quit)... "
			show_hand
			hand.cards.each_with_index do |card, idx|
				next if indices.include?(idx)
				puts "#{idx + 1}: #{card}"
			end
			input = gets.chomp
			break if input == 'q'
			input = parse_input(input)
			next if !input.between?(0, 4)
			indices << input
		end
		indices
	end

	private
	def parse_input(input)
		input = input.to_i - 1
	end
end