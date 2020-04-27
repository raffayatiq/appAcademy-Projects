class Hangman
  DICTIONARY = ["cat", "dog", "bootcamp", "pizza"]

  def self.random_word
  	DICTIONARY.sample
  end

  def initialize
  	@secret_word = Hangman.random_word
  	@guess_word = Array.new(@secret_word.length, "_")
  	@attempted_chars = []
  	@remaining_incorrect_guesses = 5
  end

  def guess_word
  	@guess_word
  end

  def attempted_chars
  	@attempted_chars
  end

  def remaining_incorrect_guesses
  	@remaining_incorrect_guesses
  end

  def already_attempted?(char)
  	if @attempted_chars.include?(char)
  		true
  	else
  		false
  	end
  end

  def get_matching_indices(char)
  	finalArr = []
  	@secret_word.each_char.with_index do |secretchar, idx|
  		if char == secretchar
  			finalArr << idx
  		end
  	end
  	finalArr
  end

  def fill_indices(char, array)
  	array.each do |ele|
  		@guess_word[ele] = char
  	end
  end

  def try_guess(char)
  	if self.already_attempted?(char)
  		puts "that has already been attempted"
  		return false
  	else
  		@attempted_chars << char
  		matching_indices = self.get_matching_indices(char)
  		if matching_indices.length != 0
  			fill_indices(char, matching_indices)
  		else
  			@remaining_incorrect_guesses -= 1
  		end
  		return true
  	end
  end

  def ask_user_for_guess
  	print "Enter a char:"
  	try_guess(gets.chomp)
  end

  def win?
  	if @guess_word.join("") == @secret_word
  		puts "WIN"
  		return true
  	else
  		return false
  	end
  end

  def lose?
  	if @remaining_incorrect_guesses == 0
  		puts "LOSE"
  		return true
  	else
  		return false
  	end
  end

  def game_over?
  	if self.win? || self.lose?
  		puts @secret_word
  		return true
  	else
  		return false
  	end
  	
  end

end