class EmployeeIsAdmin < ActiveRecord::Migration
  def self.up
	add_column :employees, :is_admin, :boolean
  end

  def self.down
	remove_column :employees, :is_admin
  end
end
