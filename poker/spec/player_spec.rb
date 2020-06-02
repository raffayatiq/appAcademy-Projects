require 'player'

describe Player do
	subject(:player) { Player.new("Raffay")}
	let(:valid_hand) { double( "valid_hand", 
			:cards => ["card1", "card2", "card3", "card4", "card5"], 
			:class => Hand  
	)}

	describe "#initialize" do
		it "initializes name" do
			expect(player.name).to be_an_instance_of(String)
		end

		it "initializes pot" do
			expect(player.pot).to be_an_instance_of(Integer).and be > 0
		end

		it "initializes folded to be false" do
			expect(player.folded).to be false
		end
	end

	describe "#deal_in" do
		let(:invalid_hand) { double("invalid_hand", 
			:cards => ["card1", "card2", "card3"], 
			:class => Hand 
			)}

		it "initializes Player's @hand attribute" do
			expect(player.hand).to be_nil
			player.deal_in(valid_hand)
			expect(player.hand).to_not be_nil
		end

		it "gives it a Hand object" do
			expect(player.deal_in(valid_hand).class).to eq(Hand)
		end

		it "intializes @hand attribute to be of length 5" do
			expect(player.deal_in(valid_hand).cards.length).to eq(5)
		end

		it "raises error when @hand attribute is not of length 5" do
			expect { player.deal_in(invalid_hand).length }.to raise_error(ArgumentError, "invalid hand size")
		end
	end

	describe "#choice" do
		context "when user chooses to fold" do
			it "returns 'f'" do
				allow(player).to receive(:gets).and_return('f')
				expect(player.choice).to eq('f')
			end
		end

		context "when user chooses to see" do
			it "returns 's'" do
				allow(player).to receive(:gets).and_return('s')
				expect(player.choice).to eq('s')
			end
		end

		context "when user chooses to raise" do
			it "returns 'r'" do
				allow(player).to receive(:gets).and_return('r')
				expect(player.choice).to eq('r')
			end
		end
	end

	describe "#fold" do
		it "makes the player fold" do
			player.fold
			expect(player.folded).to be true
		end
	end

	describe "#unfold" do
		it "makes the player unfold" do
			player.unfold
			expect(player.folded).to be false
		end
	end

	let(:game) { double("game", :current_bet => 1)	}

	describe "#call" do
		it "should deduct an amount equal to the current_bet from the pot" do
			expect(player.pot).to eq(25)
			player.call(game.current_bet)
			expect(player.pot).to eq(24)
		end

		it "should return that amount" do
			expect(player.call(game.current_bet)).to eq(game.current_bet)
		end

		context "when the current_bet is larger than player's pot" do
			it "should raise an error" do
				allow(game).to receive(:current_bet).and_return(26)
				expect{ player.call(game.current_bet) }.to raise_error(ArgumentError, "insufficient pot")
			end
		end
	end

	describe "#raise_bet" do
		it "should ask the user about the amount to bet" do
			expect(player).to receive(:gets).and_return('7')
			player.raise_bet(game.current_bet)
		end

		it "should force the user to bet more than the current_bet" do
			allow(game).to receive(:current_bet).and_return(7)
			allow(player).to receive(:gets).and_return('5')
			expect{ player.raise_bet(game.current_bet) }.to raise_error(ArgumentError, "bet must be higher than current_bet")
		end

		it "should deduct that amount from the player's pot" do
			allow(player).to receive(:gets).and_return('7')
			expect(player.pot).to eq(25)
			player.raise_bet(game.current_bet)
			expect(player.pot).to eq(18)
		end

		it "should return that amount" do
			allow(player).to receive(:gets).and_return('7')
			expect(player.raise_bet(game.current_bet)).to eq(7)
		end

		context "when the amount is larger than player's pot" do
			it "should raise an error" do
				allow(player).to receive(:gets).and_return('26')
				expect{ player.raise_bet(game.current_bet) }.to raise_error(ArgumentError, "insufficient pot")
			end
		end
	end
end