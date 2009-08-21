class CreateModels < ActiveRecord::Migration
  def self.up
    create_table :models do |t|
		t.string :title
		t.integer :price
		t.integer :expiration
		t.integer :time
      t.timestamps
    end
  end

  def self.down
    drop_table :models
  end
end
