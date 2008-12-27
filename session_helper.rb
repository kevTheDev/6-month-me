module SessionHelper
  
  def signin(user)
    session[:current_user] = user.id
  end
  
  def signout
    session.delete(:current_user)
    redirect('/')
  end
  
  def connect_database
    ActiveRecord::Base.configurations = database_configuration
    ActiveRecord::Base.establish_connection(APP_ENV)
    ActiveRecord::Base.logger = Logger.new("ar.log")
  end
  
  def logged_in?
    return false unless session
    return false unless session[:current_user]
    return true
  end
  
  def current_user
    return nil unless logged_in?
    User.find(session[:current_user])
  end
  
end