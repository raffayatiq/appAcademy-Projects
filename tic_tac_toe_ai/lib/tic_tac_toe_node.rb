require_relative 'tic_tac_toe'
require 'byebug'
class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    if board.over?
      return false if board.winner == evaluator || board.winner.nil?
      return true if board.winner != evaluator
    else
       if self.next_mover_mark == evaluator
        self.children.all? { |child| child.losing_node?(evaluator) }
       else
        self.children.any? { |child| child.losing_node?(evaluator) }
      end
    end
  end

  def winning_node?(evaluator)
    if board.over?
      return false if board.winner != evaluator || board.winner.nil?
      return true if board.winner == evaluator
    else
      if self.next_mover_mark == evaluator
        self.children.any? { |child| child.winning_node?(evaluator) }
      else
        self.children.all? { |child| child.winning_node?(evaluator) }
      end
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    nodes = []
    (0..2).each do |row|
      (0..2).each do |col|
        pos = [row, col]
        if board.empty?(pos)
          dupped_board = board.dup
          dupped_board[pos] = next_mover_mark
          node = TicTacToeNode.new(dupped_board, alternate_next_mover_mark, pos)
          nodes << node
        end
      end
    end
    nodes
  end

  private
  def alternate_next_mover_mark
    next_mover_mark == :x ? :o : :x
  end
end