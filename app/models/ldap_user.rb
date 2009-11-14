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
  
  def is_admin
  	return true
  end
  
  def group
  	return self.groups[0].cn
  end
end
