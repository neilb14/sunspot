$: << File.dirname( __FILE__)
$: << File.join(File.dirname( __FILE__), 'models')
require 'sinatra'
require 'sunspot_sinatra'
require 'author'
require 'blog'
require 'location'
require 'post'
require 'post_with_auto'
require 'post_with_default_scope'
require 'photo_post'

set :logging, false
set :environment, :test
set :database_url, "sqlite3://test.db"

post '/create' do
	PostWithAuto.create(params[:post])
	return "Created"
end