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

class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients, :id => false do |t|
      t.string :ip_address, :limit => 40, :null => false
      t.integer :port, :null => false
      t.string :hostname, :null => false
      t.string :session_id, :limit => 36, :primary => true
      t.string :state
      t.references :timecode, :null => true
      t.references :user, :null => true
      t.datetime :last_request, :null => true
      t.timestamps
    end
    add_index :clients, :ip_address, :unique => true
  end

  def self.down
    drop_table :clients
  end
end
