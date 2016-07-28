require 'dotenv'
require 'better_errors'
require 'httparty'


Dotenv.load

require 'sinatra'

enable :sessions
set :session_secret, ENV['COOKIE_SECRET'] || 'asdasar88jbbak8929nalslss'


configure :development do
  use BetterErrors::Middleware
  # you need to set the application root in order to abbreviate filenames
  # within the application:
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

require './auth_helpers'

before '/secure*' do
	redirect '/' unless auth_logged_in?
end

get '/' do
	redirect '/secure' if auth_logged_in?
	erb :index
end

get '/login' do
	# redirect to twitter oauth login
end

get '/receive_code' do

   # get the code from params


queryAnswer = HTTParty.get('https://api.website.com/query/location', 
                            :query => {"token" => token})






end


