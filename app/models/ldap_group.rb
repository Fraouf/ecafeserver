class LdapGroup < ActiveLdap::Base
  ldap_mapping :dn_attribute => "cn",
               :prefix => "ou=groups",
               :classes => ["posixGroup", "top"]

  has_many     :members,
               :class => "LdapCustomer",
               :wrap => "memberUid",
               :primary_key => "uid"
end
