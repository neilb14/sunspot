require 'sinatra/base'
require './lib/sunspot/sinatra/sunspot_extension'

Dir.glob("./models/*.rb").sort.each { |f| load f }        

set :environment, :test
set :database_url, "sqlite3://test.db"

class TestApp < Sinatra::Base
	register Sinatra::SunspotExtension

	get '/' do
		"Hi."
	end
end