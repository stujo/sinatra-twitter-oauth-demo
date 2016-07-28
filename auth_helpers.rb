require 'twitter_oauth'


helpers do 

  def auth_logged_in?
  	!!session[:user]
  end

  def auth_login(user)
  	session[:user] = user
  end

  def auth_logout
  	session.delete :user
  end

  def auth_user
  	session[:user]
  end

  def auth_token_verifier(oauth_token, oauth_verifier)
  	session[:oauth_token] = oauth_token
  	session[:oauth_verifier] = oauth_verifier

	client = TwitterOAuth::Client.new(
	    :consumer_key => ENV['TWITTER_API_KEY'],
	    :consumer_secret => ENV['TWITTER_API_SECRET']
	)

	access_token = client.authorize(
	  request_token.token,
	  request_token.secret,
	  :oauth_verifier => params[:oauth_verifier]
	)

  end

end