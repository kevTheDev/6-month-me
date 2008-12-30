require 'rubygems'
require 'sinatra'

require File.expand_path(File.dirname(__FILE__) + '/lib/config')

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



# like a before filter on all actions
configure do
  connect_database
  LOGGER = Logger.new("log/#{APP_ENV}.log")
  ActiveRecord::Base.logger = LOGGER
end

error do

  'Sorry there was a nasty error - ' + request.env['sinatra.error'].name
  LOGGER.info "#{request.env['sinatra.error'].name}"
  #haml :error_unknown
end

get '/' do
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
  
  begin
  
  open_id_consumer = OpenID::Consumer.new(session, ActiveRecordStore.new)  
  check_id_request = open_id_consumer.begin(params[:open_id_input])
  
  sregreq = OpenID::SReg::Request.new

  sregreq.request_fields(["email"], true)
  check_id_request.add_extension(sregreq)
  
  
    redirect(check_id_request.redirect_url("http://localhost:4567", "http://localhost:4567/authentication_complete"))
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
    body = "You will be sent a reminder email on: #{email.send_on}"
    body += "\n"
    body += email.content
    Pony.mail(:to => current_user.email, :from => 'admin@sixmonthsme.com', :subject => 'your six month reminder', :body => body)
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
  haml :signin
end

get '/signout' do
  signout
end