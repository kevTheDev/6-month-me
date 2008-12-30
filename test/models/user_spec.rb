require 'rubygems'
require 'spec'
require 'sinatra'
require 'sinatra/test/rspec'
require 'init'
require 'lib/models/user'

require File.join(File.dirname(__FILE__), '../spec_helper')

include UserSpecHelper
include EmailSpecHelper

describe User, "create" do
  
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

describe User, "unsent_emails" do
  
  it "returns [] if no emails to be sent for this user" do
    user = create_user
    user.unsent_emails.should == []
  end
  
  it "returns an array of emails that have not been sent for this user" do
    user = create_user
    
    2.times { |n| create_email(:user_id => user.id, :sent_at => DateTime.now) }
    3.times { |n| create_email(:user_id => user.id) }
    
    user.unsent_emails.length.should == 3
  end
  
end

describe User, "sent_emails" do
  
  it "returns [] if no emails have been sent for this user" do
    user = create_user
    user.sent_emails.should == []
  end
  
  it "returns an array of emails that have been sent for this user" do
    user = create_user
    
    2.times { |n| create_email(:user_id => user.id, :sent_at => DateTime.now) }
    3.times { |n| create_email(:user_id => user.id) }
    
    user.sent_emails.length.should == 2
  end
  
end