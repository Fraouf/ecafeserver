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

class Group < ActiveRecord::Base
	belongs_to :model
	
	validates_presence_of :name
	validates_uniqueness_of :name
	validates_presence_of :price
	validates_numericality_of :price, :only_integer => true, :greater_than_or_equal_to => 0
	validates_presence_of :storage
	validates_numericality_of :storage, :only_integer => true, :greater_than_or_equal_to => 0
	
	def ldap_entry
		if @ldap_entry.nil?
			@ldap_entry = LdapGroup.find(self.name)
		end
		return @ldap_entry
	end
	
end
