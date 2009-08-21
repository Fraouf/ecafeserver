class AddCustomerIdToTimecode < ActiveRecord::Migration
  def self.up
    add_column :timecodes, :customer_id, :integer
  end

  def self.down
    remove_column :timecodes, :customer_id
  end
end
