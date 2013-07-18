#any intelligent fool can do this
require './ship'
require './grid_refactored'
require 'sinatra/base'
require 'securerandom'
require './game'

class BattleWeb < Sinatra::Base
	enable :sessions

	#max_range as a global variable; @@max_range = Game.max_range, so can change Game setting
	@@games = Hash.new  # {playerA_id: GameA, playerB_id: GameA}
	#[session[visitor1], session[visitor2]], session[game]: [session[visitor1], session[visitor2]]}
	@@lonely_player = []

	#hexashit
	def player
		session[:id]
	end
	def game
		@@games[session[:id]]
	end

	#game methods to define
	# => return_grid_of(player)

	get '/' do
		if @@lonely_player.empty? # needs_a_player? method implies game class takes care of players; encapsulate
			session[:id] = SecureRandom.uuid
			@@lonely_player << session[:id]
			redirect '/wait'
			# notify player that he needs to wait for another player to come;
			# => display a waiting view, until someone shows up
		else
			session[:id] = SecureRandom.uuid
			@@games[session[:id]] = @@games[@@lonely_player.first] = Game.new(session[:id], @@lonely_player.pop) # or Game.new(session[:id], @@lonely_player.pop)
			redirect '/start'
		end
	end

	get '/wait' do #assuming the player won't go back
		redirect '/start' if @@lonely_player.empty?
		"<h1>Waiting for another player to join</h1>"
	end

	get '/start' do
		@grid = game.own_grid(player) #encapsulate later
		@next_ship = game.next_ship(player)
		@a = :A
		@b = 1
		@start = "A1"
		erb :start
	end

	post '/start' do
		unless game.fleet_empty?(player) #unnecessary, since a check is made in 5 lines
			game.add_ship(
			    player,
				params['orientation'].to_sym,
				params['coordinate'].to_sym)
			
				redirect '/game' if game.fleet_empty?(player)
				#prevent player from shooting until the other one is ready
				redirect '/start'
		end
	end




	get '/game' do
		if !game.opponent_ready_to_play?(player)
			"<h1>Waiting for another player to place the ships</h1>"
		else
			if game.your_turn?(player)
				@print_warning = false
			else
				@print_warning = true
				#redirect '/game'
			end
			@a = :A
			@b = 1
			@start = "A1"

			@aa = :A
			@bb = 1
			@sstart = "A1"
			@own_grid = game.own_grid(player)
			@grid = game.opponent_grid(player)
			erb :game
		end
	end



	post '/game' do
		#DELETE NEXT LINE
		#@grid = game.opponent_grid(player)
		game.hit_opponent(player, params['coordinate'].to_sym)
		redirect '/game'
	end


end
=begin
	post '/game' do
		@grid = game.opponent_grid(player)
		@grid.hit?(params['coordinate'].to_sym)
		redirect '/game'

		# keep the view, but disable clicking and display a 'waiting message'
	end
=end

__END__
# => Create a player
# => raise exceptions:
# => => when go back from /game to /start, return an error, or redirect back to /game
#on the game view display your own ships & update sunk cells

# Rewrite so that each player is a new instance; or every two players are a new instance.
# => e.g. no hardcoding grid one grid 2 & two instances of fleet



get '/test/who' do
	session[:visitor]
end

get '/test' do
	if session.has_key?(:visitor)
		"key exists already exists"
	else
		session[:visitor]=rand.to_s
		@@players[session[:visitor]] = @@rack.pop
	end
end
