require 'rubygems'
require 'spec'
require 'sinatra'
require 'sinatra/test/rspec'
require 'init'

require 'openid'

PROJECT_ROOT = File.join(File.dirname(__FILE__), "..")
set_options :views => File.join(PROJECT_ROOT, "views")

describe 'My app' do
  
  it 'should show a default page' do
    get_it '/'
    @response.should be_ok
    #@response.body.should include("Hi there")
  end
  
  it "should render index template" do
    pending
    get_it '/index'
    @response.should be_ok
    #@response.should render('index')
  end
  
end

describe "MyApp", "open id submission" do
  
  it "re-renders the form if user submitted a blank open id"
  
  it "constructs an open id Consumer" do
    OpenID::Consumer.should_receive(:new)
    
    get_it '/submit_open_id', :open_id => "testopenid"
  end
  
  it "redirects to an open id provider"
  
end

describe "MyApp", "signin" do
end

describe "MyApp", "signout" do
  
  it "deletes the current_user key/value pair from the session hash" do
    #session = {}
    
    get_it '/'
    
    session[:current_user] = 1
    
    signout
    
    session.has_key?(:current_user).should be_false
  end
  
end