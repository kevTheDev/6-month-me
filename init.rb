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

include ActiveRecord

enable :sessions


get '/' do
  haml :index
end


# begin open id authentication
get '/submit_open_id' do
  
  ActiveRecord::Base.configurations = database_configuration
  ActiveRecord::Base.establish_connection(APP_ENV)
  ActiveRecord::Base.logger = Logger.new("ar.log")
  
  open_id_store = ActiveRecordStore.new
  open_id_consumer = OpenID::Consumer.new(session, open_id_store)
  
  logger = Logger.new("kev.log")
  logger.info "PARAMS: #{params.to_yaml}"


  
  check_id_request = open_id_consumer.begin(params[:open_id_input])
  
  sregreq = OpenID::SReg::Request.new
  #sregreq.request_fields User.sreg_required, true
  #sregreq.request_fields User.sreg_optional, false
  
  sregreq.request_fields(["email"], true)
  check_id_request.add_extension(sregreq)
  
  redirect(check_id_request.redirect_url("http://localhost:4567", "http://localhost:4567/authentication_complete"))


end

# end open id authentication
get '/authentication_complete' do
  
  open_id_store = ActiveRecordStore.new
  open_id_consumer = OpenID::Consumer.new(session, open_id_store)
  
  oidresp = open_id_consumer.complete(session, "/authentication_complete")
  # ...  
 # if oidresp.status == OpenID::Consumer::SUCCESS
    # ...  
    user = User.new
    user.email = params["openid.sreg.email"]
    user.save
    #user.assign_sreg_attributes! OpenID::SReg::Response.from_success_response(oidresp)
    # ...  
 # end
  
  #haml :authentication_complete
  haml :new_email
end

get '/new_email' do
  
  email = Email.new(:content => params[:email_content])
  email.save
  
  
end
