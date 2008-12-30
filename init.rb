require 'rubygems'
require 'sinatra'
require 'activerecord'
require 'erb'
require 'yaml'

require 'openid'

require File.expand_path(File.dirname(__FILE__) + '/config/setup')

require 'lib/active_record_store/active_record_store'
require 'openid/extensions/sreg'
require 'lib/models/user'
require 'lib/models/email'

require 'pony'
require 'session_helper'

include ActiveRecord
include SessionHelper


enable :sessions

helpers do
 def partial(page, options={})
   haml page, options.merge!(:layout => false)
 end
end

not_found do
  haml :error_404
end

EMAIL_DATE_FORMAT = "%m/%d/%Y"


# like a before filter on all actions
configure do
  LOGGER = Logger.new("log/development.log")    
  ENV['APP_ROOT'] ||= "#{File.dirname(__FILE__)}"

  APP_ROOT = ENV['APP_ROOT']
  APP_ENV = 'development' 
  
  ActiveRecord::Base.logger = LOGGER
  APP_URL = "http://localhost:4567"
  
  
  connect_database(:development)
end

configure :production do
  LOGGER = Logger.new("log/production.log")    
  ENV['APP_ROOT'] ||= "#{File.dirname(__FILE__)}"

  APP_ROOT = ENV['APP_ROOT']
  APP_ENV = 'production' 
  
  APP_URL = "http://sixmonthletter.com"
  
  ActiveRecord::Base.logger = LOGGER
  
  connect_database(:production)
end

configure :test do
  LOGGER = Logger.new("log/test.log")    
  ENV['APP_ROOT'] ||= "#{File.dirname(__FILE__)}"

  APP_ROOT = ENV['APP_ROOT']
  APP_ENV = 'test' 
  
  ActiveRecord::Base.logger = LOGGER
  
  connect_database(:test)
end


error do
  error = request.env['sinatra.error']
  error_string = error.message    
  error_string += error.backtrace.join("\n")
  
  LOGGER.info "ERROR: #{error_string}"
  
  haml :error_unknown
end

get '/' do
  already_logged_in
  haml :home
end

get '/about' do
  haml :about
end

get '/contact' do
  haml :contact
end


# begin open id authentication
get '/submit_open_id' do  
  
  already_logged_in
  
  begin  
    open_id_consumer = OpenID::Consumer.new(session, ActiveRecordStore.new)  
    check_id_request = open_id_consumer.begin(params[:open_id_input])
    
    sregreq = OpenID::SReg::Request.new
    
    sregreq.request_fields(["email"], true)
    check_id_request.add_extension(sregreq)
  
  
    redirect(check_id_request.redirect_url(APP_URL,  "#{APP_URL}/authentication_complete"))
  rescue OpenID::DiscoveryFailure
    @error = "Whoa there partner! Are you sure you typed your ID in right like?"
    haml :signin
  end
end

# end open id authentication
get '/authentication_complete' do
  
  open_id_consumer = OpenID::Consumer.new(session, ActiveRecordStore.new)  
  oidresp = open_id_consumer.complete(session, "/authentication_complete")

  identity_url = params["openid.identity"]
  
  #LOGGER.info "User class: #{User.class.to_s}"
  
  user = User.find_or_create_by_identity_url(identity_url)
  
  user.email = params["openid.sreg.email"]
  user.save
  
  signin(user)
  
  redirect('/new_email')
end

get '/new_email' do
  requires_login
  
  haml :new_email
end

get '/emails' do
  requires_login
  
  @emails = current_user.emails
  haml :email_index
end

get '/unsent_emails' do
  requires_login
  @emails = current_user.unsent_emails
  haml :unsent_emails
end

get '/sent_emails' do
  requires_login
  
  @emails = current_user.sent_emails
  haml :sent_emails
end

get '/emails/:id' do
  requires_login
  
  begin
    @email = current_user.emails.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    set_flash_notice("Sorry there, you can only look at your own stuff right?")
    redirect('/')
  end
  
  haml :show_email
end

post '/create_email' do
  
  requires_login
  
  email = Email.new(:content => params[:email_content], :user_id => current_user.id)
  
  if email.save 
    # send the email
    body = "You will be sent a reminder email on: #{email.send_on.strftime(EMAIL_DATE_FORMAT)}"
    body += "\n"
    body += email.content
    
    Thread.new do
      Pony.mail(:to => current_user.email, :from => 'admin@sixmonthsme.com', :subject => 'your six month reminder', :body => body)
    end
    redirect('/email_scheduled')
  else
    @error = "Now hold on a minute! You surely don't want to send yourself an empty letter do ya?"
    haml :new_email
  end
end

get '/email_scheduled' do
  haml :email_scheduled
end

get '/signin' do
  already_logged_in
  haml :signin
end

get '/signout' do
  signout
end