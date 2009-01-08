class AddPasswordsToUsers < ActiveRecord::Migration
  
  def self.up
    add_column :users, :hashed_password, :string, :limit => 40
    add_column :users, :salt, :string, :limit => 40
  end
  
  def self.down
    remove_column :users, :hashed_password
    remove_column :users, :salt
  end
  
end