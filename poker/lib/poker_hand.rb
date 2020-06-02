module PokerHand
	def ranking
		self.sort!
		case
		when royal_flush?
			:royal_flush
		when straight_flush?
			:straight_flush
		when four_of_a_kind?
			:four_of_a_kind
		when full_house?
			:full_house
		when flush?
			:flush
		when straight?
			:straight
		when three_of_a_kind?
			:three_of_a_kind
		when two_pair?
			:two_pair
		when pair?
			:pair
		else
			:high_card
		end
	end


	protected
	def flush?
		return false if cards.length < 5
		4.times do |i|
			return false if cards[i].suit != cards[i + 1].suit
		end
		return true
	end

	def straight?
		return false if cards.length < 5
		4.times do |i|
			card_value = Card::CARD_RANKS[cards[i].value]
			next_card_value = Card::CARD_RANKS[cards[i + 1].value]
			return false if next_card_value != card_value + 1
		end
		return true
	end

	def three_of_a_kind?
		return false if cards.length < 3
		3.times do |i|
			return true if cards[i..2+i].uniq { |card| card.value }.length == 1
		end
		return false
	end

	def pair?
		return false if cards.length < 2
		(cards.length - 1).times do |i|
			return true if cards[i].value == cards[i + 1].value
		end
		return false
	end

	def two_pair?
		return false if cards.length < 4
		first_possible_pair = Hand.new(cards[0..1])
		other_possible_pair = Hand.new(cards[2..-1])
		first_possible_pair.pair? && other_possible_pair.pair?
	end

	def royal_flush?
		straight_flush? && cards[-1].value == :ace
	end

	def straight_flush?
		flush? && straight?
	end

	def four_of_a_kind?
		return false if cards.length < 4
		2.times do |i|
			return true if cards[i..3+i].uniq { |card| card.value }.length == 1
		end
		return false
	end

	def full_house?
		three_of_a_kind? && cards.uniq { |card| card.value }.length == 2
	end
end