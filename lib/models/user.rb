require 'activerecord'
require File.join(File.dirname(__FILE__), '../active_record_store/active_record_store')

include ActiveRecord

class User < ActiveRecord::Base
  
  belongs_to  :open_id, :class_name => "Association", :foreign_key => :association_id
  has_many :emails
  
  validates_presence_of :email
  validates_presence_of :identity_url, :unless => :regular_signup?
  validates_presence_of :hashed_password, :if => :regular_signup?
  
  attr_accessor :regular_signup
  
  def regular_signup?
    @regular_signup
  end
  
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

  # regular authentication methods
  
  #validates_presence_of :password_confirmation
  #validates_is_confirmed :password

  # Authenticate a user based upon an e-mail and password
  # Return the user record if successful, otherwise nil
  def self.authenticate(username_or_email, pass)
    current_user = User.find_by_email(:first)
    return nil if current_user.nil? || User.encrypt(pass, current_user.salt) != current_user.hashed_password
    current_user
  end  

  # Set the user's password, producing a salt if necessary
  def password=(pass)
    @password = pass
    unless @password.nil?
      self.salt = (1..12).map{(rand(26)+65).chr}.join if !self.salt
      self.hashed_password = User.encrypt(@password, self.salt)
    end
  end

  protected
  
  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass + salt)
  end


end