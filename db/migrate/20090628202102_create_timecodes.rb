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

class CreateTimecodes < ActiveRecord::Migration
def self.up
	create_table :timecodes do |t|
		t.integer :price
		t.datetime :expiration
		t.boolean :expires, :default => true
		t.integer :time
		t.boolean :unlimited, :default => false
		t.string :code, :null => false
		t.integer :renew, :default => 0
		t.date :next_renew, :null => true
		t.integer :time_to_renew, :default => 0
		t.timestamps
	end
	
	add_index :timecodes, :code, { :unique => true }
end

def self.down
	drop_table :timecodes
end
end
