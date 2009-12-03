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
require "client_checker_worker"

class ClientCheckerWorkerTest < ActiveSupport::TestCase
	def setup
		@client_checker_worker = ClientCheckerWorker.new
	end
	
	def test_worker
		assert_difference('Client.count', -1) do
			@client_checker_worker.check
		end
	end
end