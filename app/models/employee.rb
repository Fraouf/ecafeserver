require 'digest/sha1'

class Employee < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  HUMAN_ATTRIBUTES = {
	:login	=>	"",
	:name	=>	"",
	:password	=>	I18n.t('employees.password'),
	:password_confirmation	=> I18n.t('employees.password_confirmation')
  }
  validates_presence_of     :login,    :message => :employee_login_presence
  validates_length_of       :login,    :within => 3..40, :message => :employee_login_length
  validates_uniqueness_of   :login,    :message => :employee_login_unique
  validates_format_of       :login,    :with => Authentication.login_regex, :message => :employee_bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => :employee_bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100, :message => :employee_name_length

  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :name, :password, :password_confirmation, :is_admin



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def self.human_attribute_name(attr)
    HUMAN_ATTRIBUTES[attr.to_sym] || super
  end

  def self.current
    Thread.current[:employee]
  end

  def self.current=(employee)
    raise(ArgumentError, "Invalid employee. Expected an object of class 'Employee', got #{employee.inspect}") unless employee.is_a?(Employee)
    Thread.current[:employee] = employee
  end
  
  protected
    


end
