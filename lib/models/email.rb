require 'activerecord'
require 'pony'

include ActiveRecord

class Email < ActiveRecord::Base
  
  belongs_to :user
  validates_presence_of :content
  
  after_create :calculate_send_date
  
  def sent?
    !sent_at.nil?
  end
  
  def address
    user.email
  end
  
  def self.deliver_scheduled_emails
    scheduled_emails.each do |email|
      email.deliver
    end
  end

  def deliver
    Pony.mail(:to => address, :from => 'noreply@sixmonthsme.com', :subject => 'A Letter From Your Past', :body => content)
    update_attribute(:sent_at, DateTime.now)
  end

  private
  
  def calculate_send_date
    update_attribute(:send_on, DateTime.now >> 6)
  end
  
  # all unsent emails that should have been sent before now
  def self.scheduled_emails    
    find(:all, :conditions => "sent_at IS NULL AND send_on < NOW() AND user_id IS NOT NULL")
  end
  
end