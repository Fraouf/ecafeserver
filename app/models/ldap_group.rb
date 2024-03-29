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

class LdapGroup < ActiveLdap::Base
	ldap_mapping :dn_attribute => "cn",
				:prefix => "ou=groups",
				:classes => ["posixGroup", "top"]

	has_many     :members,
				:class => "LdapUser",
				:wrap => "memberUid",
				:primary_key => "uid"

	def self.get_next_gid()
		gids = ActiveLdap::Base.search(:filter => 'uidNumber=*', :attributes => [ 'gidNumber'])
		max_gid = 1100
		gids.each do |gid_array|
			gid = gid_array[1]['gidNumber'][0]
			if gid.to_i > max_gid
				max_gid = gid.to_i
			end
		end
		return max_gid + 1
	end
end
