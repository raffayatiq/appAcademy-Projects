require_relative 'tile.rb'
require 'byebug'
class Board
	def self.populate_board
		grid = Array.new(9) { Array.new(9) { Tile.new } }
	end

	def initialize
		@board = Board::populate_board
		self.set_bombs
		self.set_tiles
	end

	def [](pos)
		x, y = pos
		board[x][y]
	end

	def set_bombs
		number_of_bombs = rand(5..10)
		number_of_bombs.times do
			pos = [rand(0..8), rand(0..8)]
			pos = [rand(0..8), rand(0..8)] while self[pos].bombed?
			self[pos].bomb
		end
	end

	def set_tiles
		board.each_with_index do |row, idx1|
			row.each_with_index do |tile, idx2|
				tile.set_neighbour_bomb_count(self, [idx1, idx2])
			end
		end
	end

	def render
		puts "  " + "#{(0..8).to_a.join(" ")}"
		board.each_with_index do |row, idx|
			puts idx.to_s + " " + "#{row.join(" ")}"
		end
		nil
	end

	def reveal(pos)
		tile = self[pos]
		tile.bombed? ? tile.reveal : reveal_tile_and_neighbours(tile)
	end

	def reveal_tile_and_neighbours(tile)
		if tile.neighbours.any? { |neighbour| neighbour.bombed? }
			tile.reveal
		else
			tile.reveal
			tile.neighbours.each do |neighbour|
				if neighbour.revealed?
					next
				else
					reveal_tile_and_neighbours(neighbour)
				end
			end
		end
	end

	def flag(pos)
		self[pos].flag
	end

	def bombed?(pos)
		self[pos].bombed?
	end

	def win?
		board.each do |row|
			row.each do |tile|
				if !tile.revealed?
					if tile.bombed?
						next
					else
						return false
					end
				end
			end
		end
		return true
	end

	private
	attr_reader :board
end