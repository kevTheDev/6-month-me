require 'rubygems'
require 'spec'
require 'sinatra'
require 'sinatra/test/rspec'
require 'init'
require 'lib/models/email'

require File.join(File.dirname(__FILE__), '../spec_helper')

include EmailSpecHelper


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
  
  it "calculates the send_on field" do
    email = create_email
    email.send_on.should_not be_nil
  end

end

describe Email, "sent" do
  
  it "returns true if sent_at not nil" do
    email = create_email(:sent_at => DateTime.now)
    email.should be_sent
  end
  
  it "returns false if sent_at nil" do
    email = create_email
    email.should_not be_sent
  end
  
end