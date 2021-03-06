class CreateOpenIdAssociations < ActiveRecord::Migration
  
  def self.up  
    create_table :open_id_associations do |t|
      t.string :server_url
      t.string :handle
      t.string :secret
      t.integer :issued
      t.float :lifetime,   :limit => 25
      t.string :assoc_type
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :open_id_associations
  end
  
end