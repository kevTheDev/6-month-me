require 'rubygems'
#require File.expand_path(File.dirname(__FILE__) + '/sinatra/lib/sinatra')
require 'sinatra'

require File.expand_path(File.dirname(__FILE__) + '/lib/config')

get '/' do
  'Hello world!'
end