require_relative "card.rb"

class Board
	attr_reader :size

	def initialize
		@grid = nil
		@size = nil
		self.populate
	end

	def render
		system("cls")
		print " "
		@grid.length.times do |i|
			print " " + i.to_s
		end
		puts
		@grid.each_with_index do |subarr, idx|
			print idx
			subarr.each { |ele| print (ele.revealed? ? " " + ele.face : "  ")}
			puts
		end
	end

	def populate
		@size = get_size
		@grid = Array.new(@size) { Array.new(@size) }

		((@size*@size)/2).times do
			pair = get_pair_of_cards
			2.times do 
				indices = get_valid_indices
				@grid[indices[0]][indices[1]] = pair.pop
			end
		end
	end

	def [](pos)
		@grid[pos[0]][pos[1]]
	end

	def reveal(guessed_pos)
		self[guessed_pos].reveal
	end

	def won?
		@grid.all? { |subarr| subarr.all? { |ele| ele.revealed? } }
	end

	def is_match?(pos_1, pos_2)
		self[pos_1] == self[pos_2]
	end

	def hide_cards(pos_1, pos_2)
		if !is_match?(pos_1, pos_2)
			self[pos_1].hide
			self[pos_2].hide
		end
	end

	def is_valid_guess?(guess)
		if guess.all? { |ele| ele < @size } && !self[guess].revealed?
			return true
		else
			puts "Invalid move. Choose again..."
			p guess
			sleep(3)
			return false
		end
	end

	private
	def get_pair_of_cards
		alphabets = ("A".."Z").to_a
		name_of_cards = alphabets[rand(0...alphabets.size)]
		pair = [Card.new(name_of_cards), Card.new(name_of_cards)]
	end

	def get_random_index(limit)
		rand(0...limit)
	end

	def get_size
		puts "Enter grid size: "
		size = gets.chomp.to_i
		while size % 2 != 0
			puts "Size must be an even number."
			puts "Enter grid size: "
			size = gets.chomp.to_i
		end
		size
	end

	def get_valid_indices
		index_1 = get_random_index(@size)
		index_2 = get_random_index(@size)
		while @grid[index_1][index_2].is_a?(Card)
			index_1 = get_random_index(@size)
			index_2 = get_random_index(@size)
		end
		return [index_1, index_2]
	end
end