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

class Customer < ActiveRecord::Base
  has_many :timecodes, :dependent => :destroy
  has_one  :client, :dependent => :destroy
  
  validates_presence_of     :uid,    :message => :customer_login_presence
  validates_length_of       :uid,    :within => 3..40, :message => :customer_login_length
  validates_uniqueness_of   :uid,    :message => :customer_login_unique
  validates_format_of       :uid,    :with => /\A[A-Za-z][\w\.\-_@]+\z/, :message => :customer_bad_login_message

  def time
    @time = get_time()
    write_attribute("time", @time)
    return @time
  end

  def ldap_customer
    return LdapCustomer.find(self.uid)
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
