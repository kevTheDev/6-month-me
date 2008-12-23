require 'rubygems'
require 'spec'
require 'sinatra'
require 'sinatra/test/rspec'
require 'init'

PROJECT_ROOT = File.join(File.dirname(__FILE__), "..")
set_options :views => File.join(PROJECT_ROOT, "views")

describe 'My app' do
  
  it 'should show a default page' do
    get_it '/'
    @response.should be_ok
    @response.body.should == 'Hello world'
  end
  
  it "should render index template" do
    get_it '/index'
    @response.should be_ok
    #@response.should render('index')
  end

end