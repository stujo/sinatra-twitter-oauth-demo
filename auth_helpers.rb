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

end