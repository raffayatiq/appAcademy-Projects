class Card
	attr_reader :face, :up

	def initialize(face)
		@face = face
		@up = false
	end

	def hide
		@up = false
	end

	def reveal
		@up = true
	end

	def revealed?
		@up
	end

	def ==(other_card)
		self.face == other_card.face
	end
end