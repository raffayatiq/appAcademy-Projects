class ComputerPlayer
	attr_reader :name, :score

	def initialize(name)
		@name = name
		@score = 0
		@board_size = nil
		@known_cards = Hash.new { |h, k| h[k] = [] } 
		@matched_cards = []
		@strategic_guess = nil
	end

	def get_board_size(size)
		@board_size = size
	end

	def receive_revealed_card(position, card_name)
		all_known_positions = @known_cards.values.flatten(1)
		@known_cards[card_name] << position if !all_known_positions.include?(position)
	end

	def receive_match(pos_1, pos_2)
		@matched_cards << pos_1
		@matched_cards << pos_2
	end

	def prompt
		make_strategic_guess || make_random_guess
	end

	def increase_score
		@score += 1
	end

	private
	def make_strategic_guess
		purge_all_invalid_moves
		get_strategic_guess
		if @strategic_guess != nil && @strategic_guess.length > 0
			return @strategic_guess.shift
		end
			
		return false
	end

	def purge_all_invalid_moves
		@strategic_guess = nil
		@matched_cards.each do |matched_card|
			@known_cards.each do |k, v|
				if v.include?(matched_card)
					@known_cards.delete(k)
					next
				end
			end
		end
	end

	def get_strategic_guess
		all_guesses = @known_cards.values
		all_guesses.each do |known_guess|
			if known_guess.length == 2
				@strategic_guess = known_guess
			end
		end
	end

	def make_random_guess
		guess = rand(0...@board_size), rand(0...@board_size)
		while @matched_cards.include?(guess) || @known_cards.values.flatten(1).include?(guess)
			guess = [rand(0...@board_size), rand(0...@board_size)]
		end
		puts guess
		return guess	
	end
end