require './grid_refactored'

class Game
  #attr_reader :player1, :player2
  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @players = {@player1 => Grid.new, @player2 => Grid.new}
    @turn = player2
  end


  def own_grid(player) #will conflict with attr_reader :players
    @players[player] #better name self_grid & opponents_grid
  end

  def opponent_grid(player)
    @players[opponent(player)]
  end

  def add_ship(player, orientation, coordinate)
    unless @players[player].fleet.empty?
      @players[player].load_fleet(orientation, coordinate)
    end
 end

 def next_ship(player)
  @players[player].next_ship
 end

 def fleet_empty?(player)
  @players[player].fleet_empty?
 end

  def opponent(player)
    @players.each { |k, v| return k if k != player }
  end

 def opponent_ready_to_play?(player)
  @players[opponent(player)].fleet_empty?
 end

 def hit_opponent(player, coordinate)
  
  if own_steps(player) == opponent_stpes(player)
    opponent_grid(player).hit?(coordinate)
  #else
  # raise 'Not your turn' #or false
  end
 end

def hit_opponent(player, coordinate)
  
  #if own_steps(player) == opponent_stpes(player)
  # opponent_grid(player).hit?(coordinate)
  #else
  # raise 'Not your turn' #or false
  #end
  opponent_grid(player).hit?(coordinate)
  @turn = opponent(player)
 end

  def your_turn?(player)
    @turn == player
  end


 def own_steps(player)
  opponent_grid(player).hits_and_misses.count
 end


 def opponent_stpes(player)
  own_grid(player).hits_and_misses.count
 end


end



# load_fleet method to Grid that recursively adds ships onto grid
# but here, do this:
# => def add_ship
# =>   until player.empty do
# =>     load_fleet(coordinates, orientation)
# =>   end