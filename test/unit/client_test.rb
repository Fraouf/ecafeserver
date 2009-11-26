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

require 'test_helper'

class ClientTest < ActiveSupport::TestCase
	setup :activate_authlogic
  
	def test_ip_uniqueness
		client = clients(:available)
		new_client = Client.new(:ip_address => client.ip_address)
		assert !new_client.valid?
		assert new_client.errors.invalid?(:ip_address)
	end
	
	def test_invalid_with_empty_attributes
		client = Client.new
		assert !client.valid?
		assert client.errors.invalid?(:ip_address)
		assert client.errors.invalid?(:port)
		assert client.errors.invalid?(:hostname)
		assert client.errors.invalid?(:session_id)
	end
	
	def test_port_greater_than_0
		client = clients(:available)
		client.port = 0
		assert !client.valid?
		assert client.errors.invalid?(:port)
	end
	
	def test_type_user
		client = clients(:user)
		assert_equal "user", client.type
	end
	
	def test_type_timecode
		client = clients(:timecode)
		assert_equal "timecode", client.type
	end
	
	def test_state
		client = clients(:available)
		client.state = "invalid_state"
		assert !client.valid?
		assert client.errors.invalid?(:state)
	end
end
