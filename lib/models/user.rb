require 'activerecord'
require File.join(File.dirname(__FILE__), '../active_record_store/active_record_store')

include ActiveRecord

class User < ActiveRecord::Base
  
  belongs_to  :open_id, :class_name => "Association", :foreign_key => :association_id
  has_many :emails
  
  validates_presence_of :email
  validates_presence_of :identity_url
  
  def has_emails?
    emails.any?
  end
  
  def newest_delivery_date
    return nil unless has_emails?
    emails.last
  end

  def unsent_emails
    Email.find(:all, :conditions => {
      :user_id => self.id,
      :sent_at => nil
    })
  end
  
  def sent_emails
    Email.find(:all, :conditions => "user_id = #{self.id} AND sent_at IS NOT NULL")
  end

end