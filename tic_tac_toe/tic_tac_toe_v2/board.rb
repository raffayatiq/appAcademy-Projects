class Board
	def initialize(n)
		@board = Array.new(n) { Array.new(n, '_') }
	end

	def valid?(position)
		return false if @board[position[0]] == nil
		@board[position[0]][position[1]] != nil
	end

	def empty?(position)
		@board[position[0]][position[1]] == '_'
	end

	def place_mark(position, mark)
		raise 'invalid mark' if !self.valid?(position) || !self.empty?(position) || position[0] < 0 || position[1] < 0
		@board[position[0]][position[1]] = mark
	end

	def print
		@board.each do |row|
			p row
		end
	end

	def win_row?(mark)
		number_of_rows = @board.length
		row_length = @board[0].length
		@board.each do |row|
			count = row.count { |ele| ele == mark }
			return true if count == row_length
		end
		return false
	end

	def win_col?(mark)
		transposed_board = @board.transpose
		number_of_rows = transposed_board.length
		row_length = transposed_board[0].length
		transposed_board.each do |row|
			count = row.count { |ele| ele == mark }
			return true if count == row_length
		end
		return false
	end

	def win_diagonal?(mark)
		first_diagonal = []

		(0...@board.length).each do |i|
			first_diagonal << @board[i][i]
		end
		
		second_diagonal = []
		row = @board.length - 1
		(0...@board.length).each do |col|
			second_diagonal << @board[col][row]
			row -= 1
		end

		diagonals = [first_diagonal, second_diagonal]
		diagonals.each do |diagonal|
			count = diagonal.count { |ele| ele == mark}
			return true if count == @board.length
		end

		return false
	end

	def win?(mark)
		win_row?(mark) || win_col?(mark) || win_diagonal?(mark)
	end

	def empty_positions?
		@board.each do |row|
			return true if row.any? { |ele| ele == '_'}
		end
		return false
	end

end