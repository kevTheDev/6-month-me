module UserSpecHelper
  
  protected
  
  def create_user(options={})
    params = {
      :email => "user_name",
      :identity_url => "kevthedev.myopenid.com"
    }
    
    user = User.new(params.merge(options))
    user.save
    user
  end
  
end

module EmailSpecHelper
  
  protected
  
  def create_email(options={})
    
    params = {
      :content => "email content",
      :user_id => 1
    }
    
    email = Email.new(params.merge(options))
    email.save
    email
  end
  
end

module SpecHelper
  
  include UserSpecHelper
  include EmailSpecHelper
  
  protected
  
  def clear_db
    User.delete_all
    Email.delete_all
  end
  
end