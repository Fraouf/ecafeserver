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

class User < ActiveRecord::Base

	ADMINS_GROUP_NAME = 'admins'
	EMPLOYEES_GROUP_NAME = 'employees'
	
	has_many :timecodes, :dependent => :destroy
	has_one  :client, :dependent => :destroy
	belongs_to  :group
	has_one	 :sale
	
	before_destroy :destroy_ldap

	acts_as_authentic do |c|
		c.validate_password_field = false
		c.validates_format_of_login_field_options :with => /\A[a-zA-Z0-9]+\z/
	end
	
	def destroy_ldap
		self.ldap_entry.destroy
	end
	
	def ldap_entry
		if @ldap_entry.nil?
			@ldap_entry = LdapUser.find(self.login)
		end
		return @ldap_entry
	end
	
	# Tries to find a User first by looking into the database and then by
	# creating a User if there's an LDAP entry for the given login
	def self.find_or_create_from_ldap(login)
		user_entry = find_by_login(login)
		if user_entry == nil
			user_entry = create_from_ldap_if_valid(login)
		end
		unless user_entry == nil
			# Test if user is an admin or an employee
			unless user_entry.is_admin? || user_entry.is_employee?
				return nil
			else
				return user_entry
			end
		else
			return user_entry
		end
	end

	# Creates a User record in the database if there is an entry in the LDAP
	# with the given login
	def self.create_from_ldap_if_valid(login)
		begin
			if LdapUser.find(login)
				user = LdapUser.find(login)
				group = Group.find_by_name(user.group)
				User.create(:login => login, :group_id => group.id)
			end
		rescue ActiveLdap::EntryNotFound
			nil # Don't do anything since we can't find an entry
		end
	end
	
	# Returns true if the user is an employee
	def is_employee?
		return ldap_entry.is_member_of?(User::EMPLOYEES_GROUP_NAME)
	end
	
	# Returns true if the user is an admin
	def is_admin?
		return ldap_entry.is_member_of?(User::ADMINS_GROUP_NAME)
	end
	
	def time
		@time = get_time()
		write_attribute("time", @time)
		return @time
	end

	# Decrements the timecode that expires first or does not decrement anything if the customer has unlimited time left
	def decrement_time
		unless self.timecodes.empty? && self.time == -1
			# Find the timecode that expires first
			min_timecode = nil
			unlimited = false
			self.timecodes.each do |t|
				if t.is_valid?
					if min_timecode.nil?
						min_timecode = t
					else
						if min_timecode.expires && t.expires
							min_timecode = t if t.expiration < min_timecode.expiration
						end
					end
					if t.unlimited
						unlimited = true
					end
				else
					t.destroy
				end
			end
			if unlimited == false
				if !min_timecode.nil?
					min_timecode.update_attribute("time", min_timecode.time - 1)
				end
			end
		end
	end

	protected
	
	# Authenticates the user against the LDAP.
	def valid_ldap_credentials?(password_plaintext)
		ldap_entry.bind(password_plaintext)
		ldap_entry.remove_connection
		true
		rescue ActiveLdap::AuthenticationError, ActiveLdap::LdapError::UnwillingToPerform
		false
	end
	
	private
	
	# Returns the time that the user has left
	# Returns -1 if the user has unlimited time left
	def get_time
		time = 0
		unlimited = false
		if self.is_admin? || self.is_employee?
			return -1
		end
		if self.timecodes.empty?
			return time
		else
			self.timecodes.each do |t|
				if t.is_valid?
					if t.unlimited == true
						unlimited = true
					else
						time += t.time
					end
				else
					t.destroy
				end
			end
			if unlimited == true
				return -1
			else
				return time
			end
		end
	end

end
