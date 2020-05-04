require_relative 'polytree.rb'

class KnightPathFinder
	DELTAS = [
			[-2, -1],
			[-2, 1],
			[-1, 2],
			[1, 2],
			[2, 1],
			[2, -1],
			[1, -2],
			[-1, -2]
		]

	def self.valid_moves(pos)
		valid_positions = DELTAS.map { |delta| [pos[0] + delta[0], pos[1] + delta[1]] }
		valid_positions.select do |valid_pos|
			valid_pos.all? { |num| num >= 0 && num < 8}
		end
	end

	def initialize(starting_pos)
		@root_node = PolyTreeNode.new(starting_pos)
		@considered_positions = [starting_pos]
		build_move_tree
	end

	def new_move_positions(pos)
		valid_positions = KnightPathFinder::valid_moves(pos)
		valid_positions.reject! { |valid_pos| considered_positions.include?(valid_pos) }
		@considered_positions += valid_positions
		valid_positions
	end

	def build_move_tree
		queue = [root_node]
		
		until queue.empty?
			el = queue.shift
			valid_positions = new_move_positions(el.value)
			valid_positions.each do |valid_pos|
				el.add_child(PolyTreeNode.new(valid_pos))
			end
			el.children.each { |child| queue << child }
		end

		return nil
	end

	def trace_path_back(node)
		return [node.value] if node == root_node
		trace_path_back(node.parent) + [node.value]
	end

	def find_path(end_pos)
		target_node = root_node.bfs(end_pos)
		trace_path_back(target_node)
	end

	private
	attr_reader :root_node, :considered_positions
end
