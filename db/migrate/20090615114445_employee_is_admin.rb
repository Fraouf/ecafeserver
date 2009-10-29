# Copyright (C) 2009 Guillaume Viguier-Just
#
# Author: Guillaume Viguier-Just <guillaume@viguierjust.com>
#
# This file is part of ecafeserver.
#
# Ecafeserver is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ecafeserver is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ecafeserver.  If not, see <http://www.gnu.org/licenses/>.

class EmployeeIsAdmin < ActiveRecord::Migration
  def self.up
    add_column :employees, :is_admin, :boolean
    Employee.delete_observers
    Employee.create :login => "admin", :name => "Default administrator", :password => "admin", :password_confirmation => "admin", :is_admin => "1"
  end

  def self.down
    remove_column :employees, :is_admin
  end
end
