require 'rubygems'
require 'sinatra'

require File.expand_path(File.dirname(__FILE__) + '/lib/config')

require 'activerecord'
require 'erb'
require 'sequel'
require 'sequel_core/adapters/shared/mysql'


require 'yaml'

require File.expand_path(File.dirname(__FILE__) + '/config/environment')




include ActiveRecord

enable :sessions


get '/' do
  haml :index
end


