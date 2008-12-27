require 'rubygems'
require 'sinatra'

require File.expand_path(File.dirname(__FILE__) + '/lib/config')

require 'activerecord'
require 'erb'
require 'yaml'

require 'openid'

require File.expand_path(File.dirname(__FILE__) + '/config/environment')

require 'lib/active_record_store/active_record_store'
require 'openid/extensions/sreg'
require 'lib/models/user'
require 'lib/models/email'

require 'pony'
require 'session_helper'

include ActiveRecord
include SessionHelper


enable :sessions

# like a before filter on all actions
configure do
  connect_database
  LOGGER = Logger.new("#{APP_ENV}.log")  
end

before do
  
end

get '/' do
  haml :home
end



# begin open id authentication
get '/submit_open_id' do  
  
  open_id_consumer = OpenID::Consumer.new(session, ActiveRecordStore.new)  
  check_id_request = open_id_consumer.begin(params[:open_id_input])
  
  sregreq = OpenID::SReg::Request.new

  sregreq.request_fields(["email"], true)
  check_id_request.add_extension(sregreq)
  
  redirect(check_id_request.redirect_url("http://localhost:4567", "http://localhost:4567/authentication_complete"))
end

# end open id authentication
get '/authentication_complete' do
  
  open_id_consumer = OpenID::Consumer.new(session, ActiveRecordStore.new)  
  oidresp = open_id_consumer.complete(session, "/authentication_complete")

  identity_url = params["openid.identity"]
  
  user = User.find_or_create_by_identity_url(identity_url)
  
  user.email = params["openid.sreg.email"]
  user.save
  
  signin(user)
  
  redirect('new_email')
end

get '/new_email' do
  haml :new_email
end

post '/create_email' do  
  email = Email.new(:content => params[:email_content], :user_id => current_user.id)
  
  if email.save 
    # send the email
    Pony.mail(:to => current_user.email, :from => 'admin@sixmonthsme.com', :subject => 'your six month reminder', :body => email.content)
    redirect('/email_sent')
  else
    @error = "Please write something in the box below"
    haml :new_email
  end
end

get '/email_sent' do
  haml :email_sent
end

get '/signin' do
  haml :signin
end

get '/signout' do
  signout
end