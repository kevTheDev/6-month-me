require 'rubygems'
require 'sinatra'

root = File.dirname(__FILE__)

Sinatra::Application.default_options.merge! \
  :run => false,
  :root => root,
  :app_file => File.join(root, 'init.rb'),
  :views => File.join(root, 'views'),
  :env => ENV['RACK_ENV'].to_sym || :development 

load File.join(File.dirname(__FILE__), 'init.rb')

run Sinatra.application