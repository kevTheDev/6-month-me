require 'rubygems'
require 'sinatra'

require File.expand_path(File.dirname(__FILE__) + '/lib/config')

require 'activerecord'
require 'erb'
require 'sequel'
require 'sequel_core/adapters/shared/mysql'


require 'yaml'

require 'openid'

require File.expand_path(File.dirname(__FILE__) + '/config/environment')

require 'lib/active_record_store/active_record_store'
require 'openid/extensions/sreg'
require 'lib/models/user'
require 'lib/models/email'

require 'pony'

include ActiveRecord


enable :sessions

# like a before filter on all actions
before do
  connect_database
  
end

get '/signin' do
  haml :signin
end



get '/' do
  # if logged_in?
  #     redirect('new_email')
  #     return
  #   end
  haml :index
end


# begin open id authentication
get '/submit_open_id' do
  
  
  
  open_id_store = ActiveRecordStore.new
  open_id_consumer = OpenID::Consumer.new(session, open_id_store)

  
  check_id_request = open_id_consumer.begin(params[:open_id_input])
  
  sregreq = OpenID::SReg::Request.new

  sregreq.request_fields(["email"], true)
  check_id_request.add_extension(sregreq)
  
  redirect(check_id_request.redirect_url("http://localhost:4567", "http://localhost:4567/authentication_complete"))
end

# end open id authentication
get '/authentication_complete' do
  
  open_id_store = ActiveRecordStore.new
  open_id_consumer = OpenID::Consumer.new(session, open_id_store)
  
  logger = Logger.new("kev.log")
  logger.info "SESSION KEYS: #{session.keys.to_yaml}"
  
  oidresp = open_id_consumer.complete(session, "/authentication_complete")

  
  
  
  identity_url = params["openid.identity"]
  
  user = User.find_or_create_by_identity_url(identity_url)
  
  user.email = params["openid.sreg.email"]
  user.save
  
  session[:current_user] = user.id
  
  redirect('new_email')
end

get '/new_email' do
  haml :new_email
end

get '/create_email' do
  
  email = Email.new(:content => params[:email_content])
  email.user_id = session[:current_user]
  email.save
  
  current_user_id = session[:current_user].to_s
  user = User.find(current_user_id)
  

  # send the email
  Pony.mail(:to => user.email, :from => 'admin@sixmonthsme.com', :subject => 'your six month reminder', :body => email.content)  
  
end

get '/signin' do
  redirect('/')
end

get '/signout' do
  signout
end

def signout
  #session[:current_user] = nil
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
  @current_user = User.find(session[:current_user])
  @current_user
end
