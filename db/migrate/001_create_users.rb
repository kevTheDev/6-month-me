class CreateUsers < ActiveRecord::Migration
  
  def self.up  
    create_table :users do |t|
      t.string :email
      t.integer :association_id
      t.string :identity_url
      t.timestamps
    end
  end
  
  def self.down
    drop_table :users
  end
  
end