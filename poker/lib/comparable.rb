module Comparable
	CARD_RANKING = [
		:royal_flush,
		:straight_flush,
		:four_of_a_kind,
		:full_house,
		:flush,
		:straight,
		:three_of_a_kind,
		:two_pair,
		:pair,
		:high_card
	]

	def <=>(other_hand)
		if rank_number(self) > rank_number(other_hand)
			return 1
		elsif rank_number(self) < rank_number(other_hand)
			return -1
		else
			self.sort!
			other_hand.sort!
			both_hands_ranking = self.ranking

			return 0 if both_hands_ranking == :royal_flush
			case both_hands_ranking
			when :straight_flush , :flush , :straight , :high_card
				self.cards[-1] <=> other_hand.cards[-1]
			when :four_of_a_kind
				non_unique_cards(self, 4)[-1] <=> non_unique_cards(other_hand, 4)[-1] 
			when :full_house , :three_of_a_kind
				non_unique_cards(self, 3)[-1] <=> non_unique_cards(other_hand, 3)[-1] 
			when :two_pair , :pair
				non_unique_cards(self, 2)[-1] <=> non_unique_cards(other_hand, 2)[-1]
			end
		end
	end

	protected
	def rank_number(hand)
		CARD_RANKING.reverse.index(hand.ranking) #reversed to make inequality of rankings more intuitive
	end

	def non_unique_cards(hand, n = 2)
		card_occurence = Hash.new { |h, k| h[k] = 0 }
		hand.cards.each do |card|
			card_occurence[card.value] += 1
		end

		hand.cards.select { |card| card.value == card_occurence.key(n) }
	end
end