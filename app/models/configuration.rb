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
		return RAILS_ROOT+"/config/configuration"
	end
	
	def get
		f = File.new(configuration_file, "r")
		locale = f.readline.chomp
		f.close
		out = { "locale" => locale }
		return out
	end
	
	def set
		f = File.open(configuration_file, "w")
		f.puts(@locale)
		f.close
	end
	
	def initialize
		out = get
		@locale = out['locale']
	end
end
