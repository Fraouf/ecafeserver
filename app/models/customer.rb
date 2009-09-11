require 'digest/sha1'
class Customer < ActiveRecord::Base
  include Authentication
  has_many :timecodes, :dependent => :destroy
  has_one  :client, :dependent => :destroy
  
  validates_presence_of     :login,    :message => :customer_login_presence
  validates_length_of       :login,    :within => 3..40, :message => :customer_login_length
  validates_uniqueness_of   :login,    :message => :customer_login_unique
  validates_format_of       :login,    :with => /\A[A-Za-z][\w\.\-_@]+\z/, :message => :customer_bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => :customer_bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100, :message => :customer_name_length

  attr_accessor :password
  validates_presence_of     :password, :message => :customer_password_presence, :on => :create
  validates_length_of       :password, :within => 5..40, :message => :customer_password_length, :on => :create
  before_save :encrypt_password

  HUMAN_ATTRIBUTES = {
    :login	=>	"",
    :name	=>	"",
    :password	=>	""
  }

  def self.per_page
    10
  end

  def validate_on_update
    unless self.password.blank?
      if self.password.length < 4 || self.password.length > 40
        errors.add_to_base(:customer_password_length)
      end
    end
  end

  def time
    @time = get_time()
    write_attribute("time", @time)
    return @time
  end

  def encrypt(password)
    self.class.password_digest(password, salt)
  end

  def valid_password?(password)
    crypted_password == encrypt(password)
  end
  # before filter
  def encrypt_password
    return if password.blank?
    self.salt = self.class.make_token if new_record?
    self.crypted_password = encrypt(password)
  end

  def self.human_attribute_name(attr)
    HUMAN_ATTRIBUTES[attr.to_sym] || super
  end

  def self.password_digest(password, salt)
    digest = REST_AUTH_SITE_KEY
    REST_AUTH_DIGEST_STRETCHES.times do
      digest = secure_digest(digest, salt, password, REST_AUTH_SITE_KEY)
    end
    digest
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

  private
  # Returns the time that the customer has left
  # Returns -1 if the customer has unlimited time left
  def get_time
    time = 0
    unlimited = false
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
