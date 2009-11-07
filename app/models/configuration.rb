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

require 'singleton'
class Configuration
	include Singleton
	
	attr_reader :locale
	
	def save (params)
		locale = params[:country]
		if (!AVAILABLE_LOCALES.include?(locale))
			return 'invalid_locale'
		end
		@locale = locale
		set
		return true
	end
		
	protected
	def configuration_file
		return RAILS_ROOT+"/config/config.yml"
	end
	
	def set
		a_config = YAML.load_file configuration_file
		a_config[RAILS_ENV]["language"] = @locale
		File.open(configuration_file, 'w') { |f| YAML.dump(a_config, f) }
		APP_CONFIG['language'] = @locale
	end
	
	def initialize
		out = get
		@locale = APP_CONFIG['language']
	end
end
