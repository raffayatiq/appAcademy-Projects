require_relative 'item.rb'

class List
	attr_accessor :label

	def initialize(label)
		@label = label
		@items = []
	end

	def add_item(title, deadline, description="")
		if Item::valid_date?(deadline)
			@items << Item.new(title, deadline, description)
			return true
		else
			puts "Invalid deadline."
			return false
		end
	end

	def size
		@items.length
	end

	def valid_index?(index)
		index >= 0 && @items[index] != nil
	end

	def swap(index_1, index_2)
		return false if !self.valid_index?(index_1) || !self.valid_index?(index_2)
		@items[index_1], @items[index_2] = @items[index_2], @items[index_1]
		return true
	end

	def [](index)
		return nil if !self.valid_index?(index)
		@items[index]
	end

	def priority
		@items[0]
	end

	def print
		puts @label
		@items.each_with_index do |item, idx|
			puts idx.to_s.ljust(5) + "|" + item.title.ljust(20) + "|" + item.deadline.ljust(15) + (item.done ? 'Done' : 'Not Done')
		end
		return nil
	end

	def print_full_item(index)
		return if !self.valid_index?(index)
		item = @items[index]
		puts item.title.ljust(15) + item.deadline
		puts item.description.ljust(15) + (item.done ? 'Done' : 'Not Done')
		return nil
	end

	def print_priority
		item = @items[0]
		puts item.title.ljust(15) + item.deadline
		puts item.description.ljust(15) + (item.done ? 'Done' : 'Not Done')
		return nil
	end

	def up(index, amount=1)
		return false if !self.valid_index?(index)
		i = index
		while i != 0 && amount != 0
			@items[i], @items[i - 1] = @items[i - 1], @items[i]
			i -= 1
			amount -= 1
 		end
 		return true
	end

	def down(index, amount=1)
		return false if !self.valid_index?(index)
		i = index
		while i != (self.size - 1) && amount != 0
			@items[i], @items[i + 1] = @items[i + 1], @items[i]
			i += 1
			amount -= 1
 		end
 		return true
	end

	def sort_by_date!
		@items.sort_by! { |item| item.deadline.split("-")[0].to_i}
		@items.sort_by! { |item| item.deadline.split("-")[1].to_i}
		@items.sort_by! { |item| item.deadline.split("-")[2].to_i}
	end

	def toggle_item(index)
		@items[index].toggle
	end

	def remove_item(index)
		return false if !self.valid_index?(index)
		@items.delete_at(index)
		return true
	end

	def purge
		i = 0
		while i < @items.length
			item = @items[i]
			if item.done
				self.remove_item(i)
				i = 0
			end
			i += 1
		end
	end
end