require_relative 'board.rb'
require 'yaml'
require 'byebug'
class Game
	def initialize
		@board = Board.new
		@game_over = false
	end

	def run
		show_board
		until game_over? || win?
			input = prompt_for_turn
			take_turn(input)
		end
	end

	def prompt_for_turn
		input = get_position_and_prefix_or_save
		input
	end

	def take_turn(input)
		if input[0] == 's'
			save
		else 
			pos = input[0..1].map(&:to_i)
			choice = input[-1]
			if choice == 'r'
				reveal(pos)
				show_board
				game_over if board.bombed?(pos)
			elsif choice == 'f'
				flag(pos)
				show_board
			end
		end
	end

	def reveal(pos)
		board.reveal(pos)
	end

	def flag(pos)
		board.flag(pos)
	end

	def save
		puts "Enter filename to save at:"
    	filename = gets.chomp

    	File.write(filename, YAML.dump(self))
	end

	private
	attr_reader :board

	def get_position_and_prefix_or_save
		puts "Enter a position (e.g. 3,4), along with a r (reveal) or f (flag) prefix (e.g. 3,4 r) OR type 's' to save"
		print ">"
		input = gets.chomp.split(',')
		until (input.length == 3 && input[-1] == 'r' || input[-1] == 'f')
			if input[0] == 's'
				break
			end
			puts "Enter a position (e.g. 3,4), along with a r (reveal) or f (flag/unflag) prefix (e.g. 3,4 r) OR type 's' to save"
			print ">"
			input = gets.chomp.split(',') 
		end
		input
	end

	def game_over
		@game_over = true
	end

	def game_over?
		if @game_over == true
			puts "You lose!"
			return true
		else
			return false
		end
	end

	def win?
		if board.win?
			puts "You win!"
			return true
		else
			return false
		end
	end

	def show_board
		system("cls")
		board.render
	end
end

if $PROGRAM_NAME == __FILE__
	case ARGV.count
	when 0
		Game.new.run
	when 1
		YAML.load_file(ARGV.shift).run
	end
end