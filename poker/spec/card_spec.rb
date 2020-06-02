require 'card'

describe Card do
	subject(:card) { Card.new(:four, :hearts) }

	describe "#initialize" do
		it "initializes card with a value string and suit" do
			expect(card.value). to eq(:four)
			expect(card.suit). to eq(:hearts)
		end

		it "raises error when given invalid value" do
			expect{ Card.new(:one, :clubs) }.to raise_error(ArgumentError, "invalid value")
		end

		it "raises error when given invalid suit" do
			expect{ Card.new(:two, :emerald) }.to raise_error(ArgumentError, "invalid suit")
		end
	end

	describe "#<=>" do
		it "returns 0 when card is same" do
			expect(Card.new(:ten, :spades) <=> Card.new(:ten, :spades)).to eq(0)
		end

		it "returns 1 when card has higher value" do
			expect(Card.new(:ace, :spades) <=> Card.new(:ten, :spades)).to eq(1)
		end

		it "returns 1 when card has equal value but higher suit" do
			expect(Card.new(:two, :spades) <=> Card.new(:two, :clubs)).to eq(1)
		end

		it "returns -1 when card has lower value" do
			expect(Card.new(:two, :spades) <=> Card.new(:three, :spades)).to eq(-1)
		end

		it "returns -1 when card has equal value but lower suit" do
			expect(Card.new(:ace, :clubs) <=> Card.new(:ace, :spades)).to eq(-1)
		end
	end
end