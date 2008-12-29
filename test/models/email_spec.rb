require 'rubygems'
require 'spec'
require 'sinatra'
require 'sinatra/test/rspec'
require 'init'
require 'lib/models/email'

describe Email, "create" do
  
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
  
  protected
  
  def create_email(options={})
    params = {
      :content => "email content"
    }
    
    email = Email.new(params.merge(options))
    email.save
    email
  end
  
end
