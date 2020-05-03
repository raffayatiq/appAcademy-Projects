module Searchable
	def dfs(target_value)
		return self if self.value == target_value

		self.children.each do |child|
			search_result = child.dfs(target_value)
			return search_result unless search_result.nil?
		end
		return nil
	end

	def bfs(target_value)
		queue = [self]
		until queue.empty?
			el = queue.shift
			return el if el.value == target_value
			el.children.each { |child| queue << child }
		end
		return nil
	end
end

class PolyTreeNode
	include Searchable

	attr_reader :parent, :value
	attr_accessor :children

	def initialize(value)
		@value = value
		@parent = nil
		@children = []
	end

	def parent=(new_parent)
		parent.children -= [self] unless parent.nil?
		@parent = new_parent
		new_parent.children << self unless parent.nil?
	end

	def add_child(child_node)
		child_node.parent = self
	end

	def remove_child(child_node)
		raise "Not the current node's child" if child_node.parent != self
		child_node.parent = nil
	end

	def inspect
		inspect_hash = { 'value' => @value, 'parent value' => nil, 'children values' => [] }
		inspect_hash['parent value'] = parent.value unless parent.nil?
		self.children.each do |child|
			inspect_hash['children values'] << child.value
		end
		inspect_hash.inspect
	end
end