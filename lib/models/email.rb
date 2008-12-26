require 'activerecord'

include ActiveRecord

class Email < ActiveRecord::Base
  
  belongs_to :user
  
end