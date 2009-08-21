class CreateTimecodes < ActiveRecord::Migration
  def self.up
    create_table :timecodes do |t|
		t.integer :price
		t.datetime :expiration
		t.boolean :expires
		t.integer :time
		t.boolean :unlimited
		t.string :code
      t.timestamps
    end
  end

  def self.down
    drop_table :timecodes
  end
end
