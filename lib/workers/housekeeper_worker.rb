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

# This agent performs the following operations on the database 
# every 24 hours: removes invalid timecodes and renews timecodes that need
# to be renewed

class HousekeeperWorker < BackgrounDRb::MetaWorker
	set_worker_name :housekeeper_worker
	def create(args = nil)
		# this method is called, when worker is loaded for the first time
	end
	
	# Cleans the database by removing invalid timecodes and renewing timecodes that
	# need to be renewed
	def clean
		today = Date.today
		Timecode.find_each do |timecode|
			# Destroy if invalid
			if !timecode.is_valid?
				timecode.destroy
			else
				# Renew if needed
				if timecode.renew > 0 && timecode.next_renew <= today
					timecode.update_attributes({:time => timecode.time, :next_renew => today + timecode.renew.day})
				end
			end
		end
		
	end
end

