require 'lib/sinatra/lib/sinatra'
 
Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production
)
 
require 'init'
run Sinatra.application