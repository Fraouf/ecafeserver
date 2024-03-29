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

class ConfigurationsController < ApplicationController
	before_filter :admin_required
	
	def new
		@configuration = Configuration.instance
	end
	
	def create
		@config = Configuration.instance
		response = @config.save(params)
		logger.debug "Config: #{params.inspect}"
		if response == true
			I18n.locale = @config.locale
			flash[:notice] = t 'configuration.changed_successfully'
		else
			case response
				when 'invalid_locale'
					flash[:error] = t 'configuration.invalid_locale'
			end
		end
		redirect_to :controller => "configurations", :action => "new"
	end
end
