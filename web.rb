#require './ship'
#require './grid_refactored'
require 'sinatra'


get '/' do
	@max_range = 10
	@a = :A
	@b = 1
	@symbol = "A1"
	@start = "A1"
	erb :index
end