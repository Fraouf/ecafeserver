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

require 'aasm'
class Client < ActiveRecord::Base
  set_primary_key "session_id"
  include UuidHelper
  include AASM
  belongs_to :user
  belongs_to :timecode

  validates_presence_of :ip_address
  validates_uniqueness_of :ip_address
  validates_presence_of :port
  validates_numericality_of :port, :only_integer => true, :greater_than => 0
  validates_presence_of :hostname
  validates_presence_of :state
  validates_inclusion_of :state, :in => %w(available connected)
  validates_presence_of :session_id

  aasm_column :state
  aasm_initial_state :available

  aasm_state :available
  aasm_state :connected

  aasm_event :connect do
    transitions :to => :connected, :from => [:available]
  end

  aasm_event :disconnect do
    transitions :to => :available, :from => [:connected]
  end

  aasm_event :timeout do
    transitions :to => :available, :from => [:connected]
  end
  
  def type
    if self.user.nil?
      if self.timecode.nil?
        return ""
      else
        return "timecode"
      end
    else
      return "user"
    end
  end

end
