require 'game.rb'

describe Game do
	subject(:game) { Game.new }

	describe "#initialize" do
		it "initializes a game of four players" do
			expect(game.players.length).to eq(4)
			game.players.each do |player|
				expect(player).to be_an_instance_of(Player)
			end
		end

		it "initializes a pot to zero" do
			expect(game.pot).to eq(0)
		end

		it "initializes a deck of cards" do
			expect(game.deck).to be_an_instance_of(Deck)
			expect(game.deck.cards.length).to eq(32) #this is after the 4 players have been delt in
		end

		it "initializes variable to track current player" do
			expect(game.current_player).to eq(game.players[0])
		end
	end

	describe "#switch_player" do
		it "switches current player to next player" do
			expect(game.current_player.name).to eq("1")
			game.switch_player
			expect(game.current_player.name).to eq("2")
		end
	end

	describe "#deal_in_players" do
		it "deals in the four players" do
			game.deal_in_players
			game.players.each do |player|
				expect(player.hand).to be_an_instance_of(Hand)
				expect(player.hand.cards.length).to eq(5)
			end
		end
	end

	describe "#showdown" do

		it "compares the cards of each player" do
			expect(game.players[0].hand).to receive(:<=>).with(game.players[1].hand)
			expect(game.players[1].hand).to receive(:<=>).with(game.players[2].hand)
			expect(game.players[2].hand).to receive(:<=>).with(game.players[3].hand)
			game.showdown
		end

		it "skips players who have folded" do
			game.players.each do |player|
				player.fold
				expect(player.hand).to_not receive(:<=>)
			end
			game.showdown
		end

		it "returns nil if there is no winning player" do
			game.players.each do |player|
				player.fold
			end
			expect(game.showdown).to eq(nil)
		end
	end
end