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

class GroupTest < ActiveSupport::TestCase
	setup :activate_authlogic
	
	def test_invalid_with_empty_attributes
		group = Group.new
		assert !group.valid?
		assert group.errors.invalid?(:name)
		assert group.errors.invalid?(:price)
		assert group.errors.invalid?(:storage)
	end
	
	def test_name_uniqueness
		group = Group.new(:name => "students")
		assert !group.valid?
		assert group.errors.invalid?(:name)
	end
	
	def test_price
		group = groups(:students)
		group.price = -1
		assert !group.valid?
		assert group.errors.invalid?(:price)
	end
	
	def test_storage
		group = groups(:students)
		group.storage = -1
		assert !group.valid?
		assert group.errors.invalid?(:storage)
	end
	
end
