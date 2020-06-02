require 'deck'

describe Deck do
	subject(:deck) { Deck.new }

	describe "#initialize" do
		it "creates a deck of 52 cards" do
			expect(deck.cards.count).to eq(52)
		end

		it "does not create duplicates" do
			expect(deck.cards.uniq { |card| [card.value, card.suit] }.count).to eq(52)
		end
	end

	describe "#shuffle" do
		it "shuffles the cards" do
			test_deck = Deck.new
			expect(deck.cards).to eq(test_deck.cards)
			deck.shuffle
			expect(deck.cards).to_not eq(test_deck.cards)
		end
	end

	describe "#take_cards" do
		it "returns a number of cards from the deck" do
			expect(deck.take_cards(3).length).to eq(3)
		end

		it "should return an array of cards from the deck" do
			cards_taken = deck.take_cards(3)

			expect(cards_taken).to be_an_instance_of(Array)
			cards_taken.each { |card| expect(card).to be_an_instance_of(Card) }
		end
	end

	describe "#deal_hand" do
		it "should take 5 cards out of the deck" do
			expect(deck).to receive(:take_cards).with(5)
			deck.deal_hand
		end
	end

	describe "#return_cards" do
		it "should return the cards to the deck" do
			expect(deck.cards.count).to eq(52)
			cards_taken = deck.take_cards(5)
			expect(deck.cards.count).to eq(47)
			deck.return_cards(cards_taken)
			expect(deck.cards.count).to eq(52)
		end

		it "should return cards to the bottom of the deck" do
			cards_taken = deck.take_cards(5)
			deck.return_cards(cards_taken)
			expect(cards_taken).to_not eq(deck.cards[-5..-1])
		end
	end
end