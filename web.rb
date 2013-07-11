require './ship'
require './grid_refactored'
require 'sinatra'

@@grid = Grid.new
#@@fleet = {carrier: 5, battleship: 4, cruiser: 3, destroyer: 2, submarine: 1}
@@fleet = [[:carrier, 5], [:battleship, 4], [:cruiser, 3], [:destroyer, 2], [:submarine, 1]]
@@settings = {}
get '/start' do
	@a = :A
	@b = 1
	@start = "A1"
	erb :start
end


post '/start' do
	while !@@fleet.empty?
	  @@grid.place(
	    Ship.new(@@fleet.shift[1]),
		params['orientation'].to_sym,
		params['coordinate'].to_sym)
		
		redirect '/game' if @@fleet.empty?
		redirect '/start'
	end
end

get '/game' do
	@a = :A
	@b = 1
	@start = "A1"
	erb :game
end

post '/game' do
	@@grid.hit?(params['coordinate'].to_sym)
	redirect '/game'
end

=begin
# => Create a player
# => raise exceptions
=end