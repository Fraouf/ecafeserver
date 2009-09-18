require 'digest/sha1'
class LdapCustomer < ActiveLdap::Base
  ldap_mapping :dn_attribute => "uid",
               :prefix => "ou=People",
               :classes => ['person','posixAccount','shadowAccount','inetOrgPerson']

  before_save :encrypt_password

  def encrypt_password()
    encrypted = Digest::SHA1.hexdigest(self.userPassword)
    self.userPassword = '{sha}' + encrypted
  end
end
