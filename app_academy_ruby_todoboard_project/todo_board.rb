require_relative 'list.rb'

class TodoBoard
	def initialize(label)
		@lists = Hash.new
	end

	def get_command
		print "\nEnter a command: "
		cmd, list_label, *args = gets.chomp.split(' ')
		args = args.map { |arg| arg.to_i } if cmd != 'mktodo'

		case cmd
			when 'mklist'
				@lists[list_label] = List.new(list_label)
			when 'ls'
				puts @lists.keys
			when 'showall'
				@lists.each { |key, value| value.print}
			when 'mktodo'
				@lists[list_label].add_item(*args)
			when 'up'
				@lists[list_label].up(*args)
			when 'down'
				@lists[list_label].down(*args)
			when 'swap'
				@lists[list_label].swap(*args)
			when 'sort'
				@lists[list_label].sort_by_date!
			when 'priority'
				@lists[list_label].print_priority
			when 'print'
				args.length == 0 ? @lists[list_label].print : @lists[list_label].print_full_item(*args)
			when 'toggle'
				@lists[list_label].toggle_item(*args)
			when 'rm'
				@lists[list_label].remove_item(*args)
			when 'purge'
				@lists[list_label].purge
			when 'quit'
				return false
			else
				print "Sorry, that command is not recognized."
			end

		true
	end

	def run
		while self.get_command
		end
	end
end