require_relative 'card'
require_relative 'poker_hand'
require_relative 'comparable'

class Hand
	include PokerHand
	include Comparable

	attr_reader :cards

	def initialize(cards)
		@cards = cards
	end

	def sort!
		@cards.sort! { |a, b| a <=> b }
	end

	#this method is needed to make sort! spec not give a false negative.
	#it'll give a false negative if it is comparing object identities as well as values and suits.
	#this method will exclude comparison of object identities
	def ==(other_hand)
		self.sort!
		other_hand.sort!
		
		5.times do |i|
			return false if self.cards[i] != other_hand.cards[i]
		end

		return true
	end

	def trade_cards(cards_index, deck)
			discarded_cards = []
			cards_index.each do |index|
				discarded_cards << @cards.delete_at(index)
			end
			@cards = cards + deck.take_cards(cards_index.length)
			deck.return_cards(discarded_cards)
	end
end