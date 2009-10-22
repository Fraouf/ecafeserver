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

module ApplicationHelper
	def flash_helper
    		f_names = [:notice, :warning, :message, :error]
    		fl = ''
    		for name in f_names
    			if flash[name]
				logger.debug "Flash name: #{name.inspect}"
				if name == :error
					fl = fl + "<div class=\"error\">#{flash[name]}</div>"
				else
    					fl = fl + "<div class=\"notice\">#{flash[name]}</div>"
				end
    			end
    			flash[name] = nil;
    		end
    		return fl
	end
end
