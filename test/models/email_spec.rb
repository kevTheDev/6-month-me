require 'rubygems'
require 'spec'
require 'sinatra'
require 'sinatra/test/rspec'
require 'init'
require 'lib/models/email'

require File.join(File.dirname(__FILE__), '../spec_helper')

include SpecHelper

describe Email, "create" do  
  
  before do
    clear_db
  end
  
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
  
  it "calculates the send_on field" do
    email = create_email
    email.send_on.should_not be_nil
  end

end

describe Email, "sent" do
  
  before do
    clear_db
  end
  
  it "returns true if sent_at not nil" do
    email = create_email(:sent_at => DateTime.now)
    email.should be_sent
  end
  
  it "returns false if sent_at nil" do
    email = create_email
    email.should_not be_sent
  end
  
end

describe Email, "address" do
  
  before do
    clear_db
  end
  
  it "returns the email address that this reminder should be sent to" do
    user = create_user
    email = create_email(:user_id => user.id)
    
    email.address.should == user.email
  end
  
end

describe Email, "scheduled_emails" do
  
  before do
    clear_db
  end
  
  it "returns [] if there are no scheduled emails" do
    Email.scheduled_emails.should == []
  end
  
  it "returns an array of scheduled emails (sent_at IS NULL && send_on < DateTime.now AND user_id IS NOT NULL)" do
    date_5_secs_ago = DateTime.now - 30
    date_10_ago = Time.now - 10
    
    2.times do |n|
      email = create_email
      email.update_attribute(:send_on, date_5_secs_ago)
    end
    
    3.times do |n|
      email = create_email(:sent_at => date_10_ago)
      email.update_attribute(:send_on, date_10_ago)
    end
    
    2.times do |n|
      email = create_email(:user_id => nil)
      email.update_attribute(:send_on, date_5_secs_ago)
    end
    
    Email.scheduled_emails.length.should == 2
  end
  
end