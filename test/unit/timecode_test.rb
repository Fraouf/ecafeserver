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

class TimecodeTest < ActiveSupport::TestCase
	setup :activate_authlogic
	
	def test_empty
		timecode = Timecode.new
		assert !timecode.valid?
	end
	
	def test_code_is_unique
		tcode = timecodes(:onehour)
		timecode = Timecode.new :code => tcode.code
		assert !timecode.valid?
	end
	
	def test_no_time_left
		timecode = timecodes(:no_time_left)
		assert !timecode.is_valid?
	end
	
	def test_expired
		timecode = timecodes(:expired)
		assert !timecode.is_valid?
	end
	
	def test_from_model
		model = models(:one_hour)
		timecode = Timecode.new_from_model(model)
		assert timecode.valid?
	end
	
	def test_renew_fields_from_model
		model = models(:thirty_minutes_per_month)
		timecode = Timecode.new_from_model(model)
		assert timecode.save
		assert_equal timecode.time_to_renew, 30
		assert_equal timecode.next_renew, Date.today + model.renew.day
	end
	
	def test_validity_of_timecode_to_renew
		timecode = timecodes(:still_valid)
		assert timecode.is_valid?
	end
	
end
