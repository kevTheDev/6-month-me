require 'rubygems'
require 'spec'
require 'sinatra'
require 'sinatra/test/rspec'
require 'init'
require 'lib/models/user'

require File.join(File.dirname(__FILE__), '../spec_helper')

describe User, "create" do
  
  include UserSpecHelper
  
  it "can be created" do
    lambda do
      create_user
    end.should change(User, :count)
  end
  
  it "requires email" do
    lambda do
      create_user(:email => nil)
    end.should_not change(User, :count)
  end
  
  it "requires identity_url" do
    lambda do
      create_user(:identity_url => nil)
    end.should_not change(User, :count)
  end
  
end

