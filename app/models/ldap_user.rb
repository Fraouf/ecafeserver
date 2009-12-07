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

require 'digest/sha1'

class LdapUser < ActiveLdap::Base
	ldap_mapping :dn_attribute => "uid",
			:prefix => "ou=people",
			:classes => ['person','posixAccount','shadowAccount','inetOrgPerson','systemQuotas']

	belongs_to  :groups,
			:class => "LdapGroup",
			:many => "memberUid"

	before_save :encrypt_password
	before_destroy :remove_groups

	def remove_groups()
		self.groups.each do |group|
			group.members.delete(self)
			group.save
		end
	end

	def encrypt_password()
		unless self.userPassword.starts_with? '{SHA}'
			encrypted = Base64.encode64(Digest::SHA1.digest(self.userPassword)).chomp
			self.userPassword = '{SHA}' + encrypted
		end
	end

	def valid_password?(password)
		self.bind(password)
		self.remove_connection
		true
		rescue ActiveLdap::AuthenticationError, ActiveLdap::LdapError::UnwillingToPerform
		false
	end

	def group
		return self.groups[0].cn
	end
	
	# Returns true if the user is a member of group_name
	def is_member_of?(group_name)
		self.groups.each do |group|
			if group.cn == group_name
				return true
			end
		end
		return false
	end
	
	def self.get_next_uid()
		uids = ActiveLdap::Base.search(:filter => 'uidNumber=*', :attributes => [ 'uidNumber'])
		max_uid = 1100
		uids.each do |uid_array|
			uid = uid_array[1]['uidNumber'][0]
			if uid.to_i > max_uid
				max_uid = uid.to_i
			end
		end
		return max_uid + 1
	end
end
