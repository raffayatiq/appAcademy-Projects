class Board

	attr_reader :size, :grid

  def initialize(n)
  	@grid = Array.new(n) { Array.new(n, :N) }
  	@size = n * n
  end

  def [](array)
  	@grid[array[0]][array[1]]
  end

  def []=(position, value)
  	@grid[position[0]][position[1]] = value
  end

  def num_ships
  	@grid.count { |ele| ele.include?(:S)}
  end

  def attack(position)
  	if self[position] == :S
  		self[position] = :H
  		puts "You sunk my battleship!"
  		true
  	else
  		self[position] = :X
  		false
  	end
  end

  def place_random_ships
  	ships_placed = []
  	row_size = @grid.length
  	position = []
  	count = 0
  	
  	while !((count / self.size.to_f) * 100 == 25 )
  		position = [rand(0...row_size), rand(0...row_size)]
  		if !ships_placed.include?(position)
  			self[position] = :S
  			ships_placed << position
  			count += 1
  		end
  	end
  end

  def hidden_ships_grid
  	hidden_grid = Array.new(@grid.length) { Array.new(@grid.length) }

  	(0...@grid.length).each do |i|
  		(0...@grid.length).each do |j|
  			if @grid[i][j] == :S
  				hidden_grid[i][j] = :N
  			else
  				hidden_grid[i][j] = @grid[i][j]
  			end
  		end
  	end

  	hidden_grid
  end

  def self.print_grid(array2D)
  	(0...array2D.length).each do |i|
  		str = ""
  		(0...array2D.length).each do |j|
  			if j == 0
  				str += array2D[i][j].to_s
  			else
  				str += " " + array2D[i][j].to_s
  			end
  		end
  		puts str
  	end
  end

  def cheat
  	Board::print_grid(@grid)
  end

  def print
  	Board::print_grid(self.hidden_ships_grid)
  end
end
