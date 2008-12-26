require 'activerecord'
require File.join(File.dirname(__FILE__), '../../vendor/plugins/acts_as_simple_registration/lib/acts_as_simple_registration')

require File.join(File.dirname(__FILE__), '../active_record_store/active_record_store')



include ActiveRecord
include ActAsSimpleRegistration

class User < ActiveRecord::Base
  
  belongs_to  :open_id, :class_name => "Association", :foreign_key => :association_id
  has_many :emails
  
  acts_as_simple_registration do
    #required :email
    #optional :nickname => :name
  end
  
end