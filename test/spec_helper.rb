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
      :content => "email content"
    }
    
    email = Email.new(params.merge(options))
    email.save
    email
  end
  
end