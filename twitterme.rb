require 'better_errors'
require 'httparty'
require 'twitter_oauth'

require 'dotenv'
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

	client = TwitterOAuth::Client.new(
	    :consumer_key => ENV['TWITTER_API_KEY'],
	    :consumer_secret => ENV['TWITTER_API_SECRET']
	)

	session[:request_token] = client.request_token(:oauth_callback => ENV['TWITTER_REDIRECT'])

    redirect session[:request_token].authorize_url
end

get '/receive_code' do
    # get the code from params

   	client = TwitterOAuth::Client.new(
	    :consumer_key => ENV['TWITTER_API_KEY'],
	    :consumer_secret => ENV['TWITTER_API_SECRET']
	)
    
	auth_response = client.authorize(
	  session[:request_token].token,
	  session[:request_token].secret,
	  :oauth_verifier => params[:oauth_verifier]
	)

	session[:access_token] = auth_response.token
	session[:secret] = auth_response.secret

	session[:user] = {
	   screen_name: auth_response.params[:screen_name],
	   twitter_id: auth_response.params[:user_id]
	}

    redirect '/secure'
end


get '/secure' do
	erb :tweet_form
end

post '/secure/tweets' do
    tweet = params[:tweet]

	client = TwitterOAuth::Client.new(
		:consumer_key => ENV['TWITTER_API_KEY'],
		:consumer_secret => ENV['TWITTER_API_SECRET'],
		:token => session[:access_token],
		:secret => session[:secret]
	)

	client.update(tweet[:message]) if client.authorized?
end


