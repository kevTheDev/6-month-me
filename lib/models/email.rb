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
    
    # send the email
    body = "Do you remember this? It's a letter from your past self"
    body += "\n\n"
    body += content
    body += "\n\n"
    body += "Did things work out as expected? If so well done! If not, don't worry, try again."
    body += "\n\n"
    body += "It's not too late to stay on track. "
    body += "Send another letter at sixmonthletter.com"
    
    Pony.mail(:to => address, :from => 'noreply@sixmonthsme.com', :subject => 'A Letter From Your Past', :body => body)
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