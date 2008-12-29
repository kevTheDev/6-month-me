require 'sinatra'
 
Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production
)
 
require File.expand_path(File.dirname(__FILE__) + '/../init')
run Sinatra.application