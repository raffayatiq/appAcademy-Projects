class Card
	attr_reader :value, :suit

	SUITS_RANKS_AND_STRINGS = {
		:clubs => "C",
		:diamonds => "D",
		:hearts => "H",
		:spades => "S"
	}

	CARD_RANKS = {
		:two => 2,
		:three => 3,
		:four => 4,
		:five => 5,
		:six => 6,
		:seven => 7,
		:eight => 8,
		:nine => 9,
		:ten => 10,
		:jack => 11,
		:queen => 12,
		:king => 13,
		:ace => 14
	}

	CARD_STRINGS = {
		:two => "2",
		:three => "3",
		:four => "4",
		:five => "5",
		:six => "6",
		:seven => "7",
		:eight => "8",
		:nine => "9",
		:ten => "10",
		:jack => "J",
		:queen => "Q",
		:king => "K",
		:ace => "A"
	}

	def initialize(value, suit)
		raise ArgumentError.new("invalid value") if !CARD_RANKS.keys.include?(value)
		raise ArgumentError.new("invalid suit") if !SUITS_RANKS_AND_STRINGS.keys.include?(suit)

		@value = value
		@suit = suit
	end

	def to_s
		CARD_STRINGS[value] + SUITS_RANKS_AND_STRINGS[suit]
	end

	def ==(other_card)
		self.value == other_card.value && self.suit == other_card.suit
	end

	def same_value?(other_card)
		self.value == other_card.value
	end

	def <=>(other_card)
		if self == other_card
			return 0
		elsif self.value != other_card.value
			CARD_RANKS[self.value] <=> CARD_RANKS[other_card.value]
		else
			suit_ranks = SUITS_RANKS_AND_STRINGS.keys
			suit_ranks.index(self.suit) <=> suit_ranks.index(other_card.suit)
		end
	end
end