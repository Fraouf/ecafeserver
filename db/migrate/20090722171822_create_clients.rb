class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients, :id => false do |t|
      t.string :ip_address, :limit => 40
      t.integer :port
      t.string :hostname
      t.string :session_id, :limit => 36, :primary => true
      t.string :state
      t.integer :timecode_id
      t.integer :customer_id
      t.datetime :last_request, :null => true
      t.timestamps
    end
    add_index :clients, :ip_address, :unique => true
  end

  def self.down
    drop_table :clients
  end
end
