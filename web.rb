require './ship'
require './grid_refactored'
require 'sinatra/base'


class BattleWeb < Sinatra::Base
	enable :sessions

	@@grid = Grid.new
	#@@fleet = {carrier: 5, battleship: 4, cruiser: 3, destroyer: 2, submarine: 1}
	@@fleet = [[:carrier, 5], [:battleship, 4], [:cruiser, 3], [:destroyer, 2], [:submarine, 1]]
	@@settings = {}

	get '/test/who' do
		session[:who]
	end

	get '/test' do
		session[:who]=rand.to_s
	end



	get '/start' do
		#session[:me]= 'cool cat'
		@a = :A
		@b = 1
		@start = "A1"
		@grid = @@grid
		@fleet = @@fleet
		erb :start
	end


	post '/start' do
		#puts session[:me]
		@grid = @@grid
		@fleet = @@fleet
		while !@fleet.empty?
		  @grid.place(
		    Ship.new(@fleet.shift[1]),
			params['orientation'].to_sym,
			params['coordinate'].to_sym)
			
			redirect '/game' if @fleet.empty?
			redirect '/start'
		end
	end

	get '/game' do
		@a = :A
		@b = 1
		@start = "A1"
		@grid = @@grid
		erb :game
	end

	post '/game' do
		@grid = @@grid
		@grid.hit?(params['coordinate'].to_sym)
		redirect '/game'
	end
end
__END__
# => Create a player
# => raise exceptions:
# => => when go back from /game to /start, return an error, or redirect back to /game
#on the game view display your own ships & update sunk cells
