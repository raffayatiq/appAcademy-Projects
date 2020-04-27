class Player
	attr_reader :name, :score

	def initialize(name)
		@name = name
		@score = 0
	end

	def prompt
		guess = gets.chomp.split(/\D/).map(&:to_i)
		while guess.length != 2
			puts "Invalid guess..."
			puts "Please enter the position of the card you'd like to flip (e.g., '2,3')"
			guess = gets.chomp.split(",").map(&:to_i)
		end
		guess
	end

	def increase_score
		@score += 1
	end

	def get_board_size(size)
		# duck typing
	end

	def receive_revealed_card(position, card_name)
		# duck typing
	end
	
	def receive_match(pos_1, pos_2)
		# duck typing
	end
end