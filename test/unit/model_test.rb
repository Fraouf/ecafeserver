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

class ModelTest < ActiveSupport::TestCase
	setup :activate_authlogic
	
	def test_invalid_with_empty_attributes
		model = Model.new
		assert !model.valid?
		assert model.errors.invalid?(:title)
		assert model.errors.invalid?(:price)
		assert model.errors.invalid?(:expiration)
		assert model.errors.invalid?(:time)
		assert model.errors.invalid?(:renew)
	end
	
	def test_price
		model = models(:one_hour)
		model.price = -1
		assert !model.valid?
		assert model.errors.invalid?(:price)
	end
	
	def test_expiration
		model = models(:one_hour)
		model.expiration = -1
		assert !model.valid?
		assert model.errors.invalid?(:expiration)
	end
	
	def test_time
		model = models(:one_hour)
		model.time = -1
		assert !model.valid?
		assert model.errors.invalid?(:time)
	end
	
	def test_renew
		model = models(:one_hour)
		model.renew = -1
		assert !model.valid?
		assert model.errors.invalid?(:renew)
	end
	
	def test_title_uniqueness
		model = models(:one_hour)
		new_model = Model.new(:title => model.title,
								:price => 30,
								:expiration => 30,
								:time => 60,
								:renew => 0)
		assert !new_model.valid?
		assert new_model.errors.invalid?(:title)
	end
end
