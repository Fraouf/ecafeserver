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

require 'sha1'
require 'base64'
class LdapCustomer < ActiveLdap::Base
  ldap_mapping :dn_attribute => "uid",
               :prefix => "ou=People",
               :classes => ['person','posixAccount','shadowAccount','inetOrgPerson']

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
    encrypted = Base64.encode64(SHA1.sha1(self.userPassword).digest).chomp
    self.userPassword = '{SHA}' + encrypted
  end

  def valid_password?(password)
    self.bind(password)
    self.remove_connection
    true
    rescue ActiveLdap::AuthenticationError, ActiveLdap::LdapError::UnwillingToPerform
      false
  end
end
