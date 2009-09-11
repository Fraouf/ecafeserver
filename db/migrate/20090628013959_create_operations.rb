class CreateOperations < ActiveRecord::Migration
  def self.up
    create_table :operations do |t|
	  t.string :user
	  t.string :operation_type
    t.string :controller
    t.string :action
    t.string :arguments
    t.timestamps
    end
  end

  def self.down
    drop_table :operations
  end
end
