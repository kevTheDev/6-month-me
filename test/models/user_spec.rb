require 'rubygems'
require 'spec'
require 'sinatra'
require 'sinatra/test/rspec'
require 'init'
require 'lib/models/user'

require File.join(File.dirname(__FILE__), '../spec_helper')

include SpecHelper

describe User, "create" do
  
  before do
    clear_db
  end
  
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
  
  it "doesn't require identity_url if regular signup process underway" do
    lambda do
      create_user(:identity_url => nil, :regular_signup => true, :password => "testpass")
    end.should change(User, :count)
  end
  
  it "requires a password if regular signup process underway" do
    lambda do
      create_user(:identity_url => nil, :regular_signup => true, :password => nil)
    end.should_not change(User, :count)
  end
    
end

describe User, "unsent_emails" do
  
  before do
    clear_db
  end
  
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
  
  before do
    clear_db
  end
  
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