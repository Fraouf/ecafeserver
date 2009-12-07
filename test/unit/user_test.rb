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

class UserTest < ActiveSupport::TestCase
	setup :activate_authlogic
	
	def test_invalid_with_empty_attributes
		user = User.new
		assert !user.valid?
		assert user.errors.invalid?(:login)
	end
	
	def test_login_uniqueness
		user = User.new(:login => "admin")
		assert !user.valid?
		assert user.errors.invalid?(:login)
	end
	
	def test_login_with_space
		user = User.new(:login => "my user")
		assert !user.valid?
		assert user.errors.invalid?(:login)
	end
	
	def test_login_non_ascii
		user = User.new(:login => "étest")
		assert !user.valid?
		assert user.errors.invalid?(:login)
	end
	
	def test_no_time_left
		user = users(:no_time_left)
		assert_equal 0, user.time
	end
	
	def test_unlimited_time
		user = users(:unlimited_time)
		assert_equal -1, user.time
	end
	
	def test_time_left
		user = users(:time_left)
		assert_equal 60, user.time
	end
	
	def test_admin_unlimited_time
		user = users(:admin)
		assert_equal -1, user.time
	end
	
	def test_employee_unlimited_time
		user = users(:employee)
		assert_equal -1, user.time
	end
end
