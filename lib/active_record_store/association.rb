require 'openid/association'
require 'time'

require File.join(File.dirname(__FILE__), '../models/user')


class Association < ActiveRecord::Base
  
  has_one :user, :foreign_key => "association_id"
  
  set_table_name 'open_id_associations'
  def from_record
    OpenID::Association.new(handle, secret, Time.at(issued), lifetime, assoc_type)
  end
end
