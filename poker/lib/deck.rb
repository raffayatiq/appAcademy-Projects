require_relative 'card.rb'

class Deck
	attr_reader :cards

	SUITS = Card::SUITS_RANKS_AND_STRINGS.keys

	VALUES = Card::CARD_RANKS.keys

	def initialize
		@cards = []
		SUITS.each do |suit|
			VALUES.each do |value|
				@cards << Card.new(value, suit)	
			end
		end
	end

	def shuffle
		@cards.shuffle!
	end

	def take_cards(amount)
		cards_taken = []
		amount.times do
			cards_taken << @cards.pop
		end
		cards_taken
	end

	def return_cards(cards)
		@cards.unshift(*cards)
	end

	def deal_hand
		take_cards(5)
	end

	def count
		@cards.length
	end
end