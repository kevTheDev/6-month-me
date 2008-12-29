require 'rubygems'
require 'spec'
require 'sinatra'
require 'sinatra/test/rspec'
require 'init'
require 'lib/models/email'

require File.join(File.dirname(__FILE__), '../spec_helper')

describe Email, "create" do
  
  include EmailSpecHelper
  
  it "can be created" do
    lambda do
      create_email
    end.should change(Email, :count)
  end
  
  it "requires content" do
    lambda do
      create_email(:content => nil)
    end.should_not change(Email, :count)
  end

end