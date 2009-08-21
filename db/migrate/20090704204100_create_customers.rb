class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :name, :limit => 100, :default => '', :null => true
      t.string :login, :limit => 40
      t.string :crypted_password, :limit => 40
      t.string :salt, :limit => 40
      t.string :email, :limit => 100, :null => true
      t.string :phone, :limit => 100, :null => true
      t.text :question
      t.text :answer
      t.datetime :last_login_at
      t.timestamps
    end
    add_index :customers, :login, :unique => true
  end

  def self.down
    drop_table :customers
  end
end
