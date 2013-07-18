require './ship'
class Grid
	attr_reader :max_range, :ships, :hits_and_misses, :fleet		#for testing only
	def initialize(max_range=10)
		@max_range = max_range
		@ships = Hash.new
		@hits_and_misses = Hash.new
	  	@fleet = [[:carrier, 5], [:battleship, 4], [:cruiser, 3], [:destroyer, 2], [:submarine, 1]]
	end

	# refactor using e_num (Pickaxe), where don't have to reasign position; the block resumes
	def generate_coordinates(ship, orientation, position)
		coordinates = []
		if orientation == :vertical
			calc = lambda { position.to_s.delete('0-9').next + position.to_s.delete('A-Z') }
		else 
			calc = lambda { position.to_s.delete('0-9') + position.to_s.delete('A-Z').next }
		end
		ship.ship_size.times do
			coordinates << position
			position = calc.call.to_sym
		end
		coordinates
	end


	def verify_ship_coordinates(coordinates)
		if valid_position?(coordinates.first)
			if valid_position?(coordinates.last)
				coordinates.each {|a| if ships.has_key?(a) then raise 'The ship crosses with another ship' end}
				#return true # do we really need to return anything?
			else
				raise 'The ship is too long to fit in the place specified. Change orientation or position of the ship.'
			end
		else raise 'The coordinate is out of valid range' end
	end


	def place(ship, orientation, position)
		raise 'The instance of the ship already exists' if ships.has_value?(ship)
		coordinates = generate_coordinates(ship, orientation, position)
		verify_ship_coordinates(coordinates).each {|coordinate| @ships[coordinate] = ship}	# bug spotted, was ships, not @ships
		return ships
	end

	def valid_position?(position)
		if ('A'..'Z').first(@max_range).include?(position.to_s.delete('0-9'))
			if ('1'..'26').first(@max_range).include?(position.to_s.delete('A-Z')) then return true end end
		false
	end
	def hit?(coordinate)
		raise 'The point has been hit already' if @hits_and_misses.has_key?(coordinate)
		if ships.has_key?(coordinate)
			ships[coordinate].hit
			@hits_and_misses[coordinate] = true
		else
			@hits_and_misses[coordinate] = false
		end
	end


	def load_fleet(orientation, position)
		if !@fleet.empty?
			self.place( Ship.new(@fleet.shift[1]), orientation, position)
		else
			raise 'The fleet is out of ships'
		end
	end

	def next_ship
		@fleet.first.first
	end

	def fleet_empty?
		@fleet.empty?
	end

end