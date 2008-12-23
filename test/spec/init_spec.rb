# #require 'minigems'
# require 'sinatra'
# require 'sinatra/test/unit'
# require 'spec'
# #require 'spec/interop/test'
# #require 'sinatra/test/methods'
# require 'sinatra/test/spec'
# #require 'rspec_hpricot_matchers'
require File.expand_path(File.dirname(__FILE__) + '../../../init')

require 'rubygems'
require 'sinatra'
require 'sinatra/test/spec'
require 'sinatra/test/rspec'


include Sinatra::Test::Methods

 
Sinatra::Application.default_options.merge!(
  :env  => :test,
  :run => false,
  :raise_errors => true,
  :logging => false
)
 
#Sinatra.application.options = nil

describe 'Init' do
  
  it "should show a default page" do
      get_it '/'
      @response.should_not be_nil
      
      puts "RESPONSE: #{@response.to_yaml}"
  #    body.should.equal 'My Default Page!'
    end



end
