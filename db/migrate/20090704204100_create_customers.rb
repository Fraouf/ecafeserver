class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :uid, :limit => 40
      t.datetime :last_login_at
      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end
