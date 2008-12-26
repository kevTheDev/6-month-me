require 'activerecord'
require File.join(File.dirname(__FILE__), '../../vendor/plugins/acts_as_simple_registration/lib/acts_as_simple_registration')

#File.join(File.dirname(__FILE__), 'database.yml')

include ActiveRecord
include ActAsSimpleRegistration

class User < ActiveRecord::Base
  
  acts_as_simple_registration do
    #required :email
    #optional :nickname => :name
  end
  
end