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

require File.join(File.dirname(__FILE__) + "/../bdrb_test_helper")
require "housekeeper_worker"

class HousekeeperWorkerTest < ActiveSupport::TestCase
	def setup
		@worker = HousekeeperWorker.new
	end
	
	def test_expired_timecodes_should_be_removed
		assert_difference('Timecode.count', -2) do
			@worker.clean
		end
	end
	
	def test_renewable_timecodes_should_be_renewed
		@worker.clean
		timecode = Timecode.find_by_code('578f9965')
		assert_equal 30, timecode.time
	end
end
