class CreateEmails < ActiveRecord::Migration
  
  def self.up  
    create_table :emails do |t|
      t.integer :user_id
      t.text    :content
      t.date    :send_on
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :emails
  end
  
end