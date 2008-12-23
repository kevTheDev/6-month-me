require 'rubygems'
require 'spec'
require 'sinatra'
require 'sinatra/test/rspec'
require 'init'
require 'lib/models/user'


describe User, "create" do
  
  it "can be created" do
    lambda do
      create_user
    end.should change(User, :count)
  end
  
  protected
  
  def create_user(options={})
    params = {
      :name => "user_name"
    }
    
    user = User.new(params.merge(options))
    user.save
    user
  end
  
end

