require 'hand'

describe Hand do
	subject(:hand) do 
		Hand.new([
			Card.new(:ace, :spades),
			Card.new(:ace, :hearts),
			Card.new(:ace, :diamonds),
			Card.new(:ace, :clubs),
			Card.new(:two, :spades)
		])
	end

	describe "#initialize" do
		it "should initialize a hand of 5 cards" do
			expect(hand.cards.count).to eq(5)
			expect(hand.cards.all? { |card| card.is_a?(Card) }).to eq(true)
		end
	end

	let(:royal_flush) do
		Hand.new([
			Card.new(:ten, :hearts),
			Card.new(:jack, :hearts),
			Card.new(:queen, :hearts),
			Card.new(:king, :hearts),
			Card.new(:ace, :hearts)
		])
	end

	let(:straight_flush) do
		Hand.new([
			Card.new(:five, :hearts),
			Card.new(:six, :hearts),
			Card.new(:seven, :hearts),
			Card.new(:eight, :hearts),
			Card.new(:nine, :hearts)
		])
	end

	let(:four_of_a_kind) do
		Hand.new([
			Card.new(:jack, :spades),
			Card.new(:jack, :clubs),
			Card.new(:jack, :diamonds),
			Card.new(:jack, :hearts),
			Card.new(:ace, :hearts)
		])
	end

	let(:full_house) do
		Hand.new([
			Card.new(:ten, :spades),
			Card.new(:ten, :clubs),
			Card.new(:ten, :diamonds),
			Card.new(:two, :hearts),
			Card.new(:two, :clubs)
		])
	end

	let(:flush) do
		Hand.new([
			Card.new(:king, :spades),
			Card.new(:ten, :spades),
			Card.new(:nine, :spades),
			Card.new(:seven, :spades),
			Card.new(:two, :spades)
		])
	end

	let(:straight) do
		Hand.new([
			Card.new(:two, :clubs),
			Card.new(:three, :spades),
			Card.new(:four, :hearts),
			Card.new(:five, :diamonds),
			Card.new(:six, :clubs)
		])
	end

	let(:three_of_a_kind) do
		Hand.new([
			Card.new(:eight, :clubs),
			Card.new(:eight, :spades),
			Card.new(:eight, :hearts),
			Card.new(:five, :diamonds),
			Card.new(:six, :clubs)
		])
	end

	let(:two_pair) do
		Hand.new([
			Card.new(:queen, :clubs),
			Card.new(:queen, :spades),
			Card.new(:four, :hearts),
			Card.new(:four, :diamonds),
			Card.new(:ace, :clubs)
		])
	end

	let(:pair) do
		Hand.new([
			Card.new(:queen, :clubs),
			Card.new(:queen, :spades),
			Card.new(:four, :hearts),
			Card.new(:six, :diamonds),
			Card.new(:ace, :clubs)
		])
	end

	let(:high_card) do
		Hand.new([
			Card.new(:ace, :diamonds),
			Card.new(:nine, :clubs),
			Card.new(:seven, :clubs),
			Card.new(:five, :clubs),
			Card.new(:three, :diamonds)
		])
	end

	describe "#ranking" do
		context "when hand is a royal flush" do
			it "should return royal flush" do
				expect(royal_flush.ranking).to eq(:royal_flush)
			end
		end

		context "when hand is a straight flush" do
			it "should return straight flush" do
				expect(straight_flush.ranking).to eq(:straight_flush)
			end
		end

		context "when hand is a four of a kind" do
			it "should return four of a kind" do
				expect(four_of_a_kind.ranking).to eq(:four_of_a_kind)
			end
		end

		context "when hand is a full house" do
			it "should return full house" do
				expect(full_house.ranking).to eq(:full_house)
			end
		end

		context "when hand is a flush" do
			it "should return flush" do
				expect(flush.ranking).to eq(:flush)
			end
		end

		context "when hand is a straight" do
			it "should return straight" do
				expect(straight.ranking).to eq(:straight)
			end
		end

		context "when hand is a three of a kind" do
			it "should return three of a kind" do
				expect(three_of_a_kind.ranking).to eq(:three_of_a_kind)
			end
		end

		context "when hand is a two pair" do
			it "should return two pair" do
				expect(two_pair.ranking).to eq(:two_pair)
			end
		end

		context "when hand is a pair" do
			it "should return pair" do
				expect(pair.ranking).to eq(:pair)
			end
		end

		context "when hand is a high card" do
			it "should return high card" do
				expect(high_card.ranking).to eq(:high_card)
			end
		end
	end

	let (:hands) {[
			royal_flush,
			straight_flush,
			four_of_a_kind,
			full_house,
			flush,
			straight,
			three_of_a_kind,
			two_pair,
			pair,
			high_card
		]}

	describe "#<=>" do
		it "returns 1 when hand is higher ranked" do
			hands[0..-2].each_with_index do |hand1, idx|
				hands[idx+1..-1].each do |hand2|
					expect(hand1 <=> hand2).to eq(1)
				end
			end
		end

		it "returns -1 when hand is lower ranked" do
			hands.reverse[0..-2].each_with_index do |hand1, idx|
				hands.reverse[idx+1..-1].each do |hand2|
					expect(hand1 <=> hand2).to eq(-1)
				end
			end
		end

		let(:identical_royal_flush) do
			Hand.new([
				Card.new(:ten, :spades),
				Card.new(:jack, :spades),
				Card.new(:queen, :spades),
				Card.new(:king, :spades),
				Card.new(:ace, :spades)
			])
		end

		it "returns 0 when hand is identical" do
				expect(royal_flush <=> identical_royal_flush).to eq(0)
			end

		let(:winning_four_of_a_kind) do
			Hand.new([
				Card.new(:queen, :spades),
				Card.new(:queen, :clubs),
				Card.new(:queen, :diamonds),
				Card.new(:queen, :hearts),
				Card.new(:ace, :hearts)
			])
		end

		let(:losing_high_card) do
			Hand.new([
				Card.new(:four, :diamonds),
				Card.new(:nine, :clubs),
				Card.new(:seven, :clubs),
				Card.new(:five, :clubs),
				Card.new(:three, :diamonds)
			])
		end

		let(:losing_full_house) do
			Hand.new([
				Card.new(:nine, :spades),
				Card.new(:nine, :clubs),
				Card.new(:nine, :diamonds),
				Card.new(:two, :hearts),
				Card.new(:two, :clubs)
			])
		end

		it "returns correct number when hand is equal ranked but contains higher cards" do
			expect(four_of_a_kind <=> winning_four_of_a_kind).to eq(-1)
			expect(winning_four_of_a_kind <=> four_of_a_kind).to eq(1)
			expect(high_card <=> losing_high_card).to eq(1)
			expect(losing_high_card <=> high_card).to eq(-1)
			expect(full_house <=> losing_full_house).to eq(1)
			expect(losing_full_house <=> full_house).to eq(-1)
		end
	end

	describe "#sort!" do
		it "sorts cards in hand" do
			hand = Hand.new([
				Card.new(:king, :spades),
				Card.new(:ten, :spades),
				Card.new(:nine, :spades),
				Card.new(:seven, :spades),
				Card.new(:two, :spades)
			])

			sorted_hand = Hand.new([
				Card.new(:two, :spades),
				Card.new(:seven, :spades),
				Card.new(:nine, :spades),
				Card.new(:ten, :spades),
				Card.new(:king, :spades)
			])

			hand.sort!

			expect(hand).to eq(sorted_hand)
		end
	end

	describe "#trade_cards" do
		let(:hand_clone) do 
			Hand.new([
				Card.new(:ace, :spades),
				Card.new(:ace, :hearts),
				Card.new(:ace, :diamonds),
				Card.new(:ace, :clubs),
				Card.new(:two, :spades)
			])
		end

		let(:deck) { double("deck", :take_cards => [
			Card.new(:four, :hearts),
			Card.new(:six, :diamonds),
			Card.new(:ace, :clubs)
		]) }

		it "discards cards in hand and trades them for new cards" do
			expect(hand).to eq(hand_clone)
			expect(deck).to receive(:take_cards).with(3)
			allow(deck).to receive(:return_cards)
			hand.trade_cards([0, 2, 4], deck)
			expect(hand).to_not eq(hand_clone)
		end
	end
end