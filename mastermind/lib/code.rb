class Code
  POSSIBLE_PEGS = {
    "R" => :red,
    "G" => :green,
    "B" => :blue,
    "Y" => :yellow
  }

  def self.valid_pegs?(char_array)
  	char_array.each { |char| char.upcase! }
  	char_array.all? { |char| POSSIBLE_PEGS.has_key?(char) }
  end

  attr_reader :pegs

  def initialize(char_array)
  	if Code.valid_pegs?(char_array)
  		@pegs = char_array
  	else
  		raise "Invalid pegs."
  	end
  end

  def self.random(length)
  	possible = ["R", "G", "B", "Y"]
  	arr = Array.new(length)
  	arr = arr.map { |peg| possible[rand(0...4)]}
  	Code.new(arr)
  end

  def self.from_string(pegs_string)
  	Code.new(pegs_string.split(""))
  end

  def [](index)
  	@pegs[index]
  end

  def length
  	@pegs.length
  end

  def num_exact_matches(guess)
  	count = 0
  	(0...guess.pegs.length).each do |i|
  		count += 1 if guess.pegs[i] == @pegs[i]
  	end
  	count
  end

  def num_near_matches(guess)
  	count = 0
  	(0...guess.pegs.length).each do |i|
  		count += 1 if @pegs.include?(guess.pegs[i]) && !(guess.pegs[i] == @pegs[i]) 
  	end
  	count
  end

  def ==(other_code)
  	return false if other_code.length != self.length
  	self.num_exact_matches(other_code) == self.length
  end
end
