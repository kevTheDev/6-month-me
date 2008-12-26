require 'activerecord'
require File.join(File.dirname(__FILE__), '../active_record_store/active_record_store')

include ActiveRecord

class User < ActiveRecord::Base
  
  belongs_to  :open_id, :class_name => "Association", :foreign_key => :association_id
  has_many :emails

end