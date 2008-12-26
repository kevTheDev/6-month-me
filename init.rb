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


include ActiveRecord

enable :sessions


get '/' do
  haml :index
end

get '/submit_open_id' do
  
  ActiveRecord::Base.configurations = database_configuration
  ActiveRecord::Base.establish_connection(APP_ENV)
  ActiveRecord::Base.logger = Logger.new("ar.log")
  
  open_id_store = ActiveRecordStore.new
  open_id_consumer = OpenID::Consumer.new(session, open_id_store)
  
  #puts "open_id_store: #{open_id_store.class}"
  
  #puts "Consumer: #{open_id_consumer.class}"
  
  open_id_consumer.begin("kevthedev.myopenid.com")
  
  #{}"hello"
end


