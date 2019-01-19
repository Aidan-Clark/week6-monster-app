require "sinatra"
require "sinatra/contrib"
require "sinatra/reloader" if development?
require_relative "controllers/monsters_controller.rb"
require_relative "models/monster.rb"

use Rack::MethodOverride
run MonstersController
