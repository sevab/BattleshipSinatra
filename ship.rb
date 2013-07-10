class Ship

	attr_reader :ship_size, :damage

	def initialize(size)
		@ship_size = size
		@damage = 0
	end 

	def hit
		if damage < ship_size
			@damage+=1
			# if damage == ship_size then return sunk
		else #no use for lines below, a sunk ship should not be allowed to be hit again anyways
			raise 'The ships is sunk, cannot damage more'
		end
	end

end 



=begin
	def generate_coordinates(ship, orientation, position)
		coordinates = []
		ship.ship_size.times do
			coordinates << position
			if orientation == :vertical then position = (position.to_s.delete('0-9').next + position.to_s.delete('A-Z')).to_sym
			else position = (position.to_s.delete('0-9') + position.to_s.delete('A-Z').next).to_sym end
		end
		coordinates
	end
=end