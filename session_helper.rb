module SessionHelper
  
  def signin(user)
    session[:current_user] = user.id
  end
  
  def signout
    clear_session
    redirect('/')
  end
  
  def clear_session
    session.delete(:current_user)
    clear_flash    
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
  
  def requires_login
    unless logged_in?
      set_flash_notice("Sorry, members only")
      redirect('/')
    end
  end
  
  def set_flash_notice(message)
    set_flash_message(message, :notice)
  end
  
  def set_flash_error(message)
    set_flash_message(message, :error)
  end
  
  def set_flash_message(message, message_type)
    session[message_type] = message
  end
  
  def clear_flash
    session.delete(:notice)
    session.delete(:error)
  end
  
end