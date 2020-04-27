require_relative "code"

class Mastermind
	def initialize(length)
		@secret_code = Code.new((Code.random(length)).pegs)
	end

	def print_matches(code_instance)
		puts "exact matches: " + @secret_code.num_exact_matches(code_instance).to_s
		puts "near matches: " + @secret_code.num_near_matches(code_instance).to_s
	end

	def ask_user_for_guess
		puts "Enter a code: "
		guess = Code.from_string(gets.chomp)
		self.print_matches(guess)
		guess == @secret_code
	end
end
