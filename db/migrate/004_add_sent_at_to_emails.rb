class AddSentAtToEmails < ActiveRecord::Migration
  
  def self.up
    add_column :emails, :sent_at, :datetime
  end
  
  def self.down
    remove_column :emails, :sent_at
  end
  
end