require 'activerecord'

include ActiveRecord

class Email < ActiveRecord::Base
  
  belongs_to :user
  validates_presence_of :content
  
  after_create :calculate_send_date
  
  def sent?
    !sent_at.nil?
  end
  
  private
  
  def calculate_send_date
    update_attribute(:send_on, DateTime.now >> 6)
  end
  
end