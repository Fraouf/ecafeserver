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

class ClientCheckerWorker < BackgrounDRb::MetaWorker
	set_worker_name :client_checker_worker
	def create(args = nil)
		# this method is called, when worker is loaded for the first time
	end

	# Destroys all clients that have not sent a request for 1 minute
	def check
		clients = Client.find :all
		now = Time.now
		clients.each do |client|
			if now - client.updated_at > 1.minute
				client.destroy
			end
		end
	end
end

