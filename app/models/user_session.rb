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

class UserSession < Authlogic::Session::Base
	find_by_login_method :find_or_create_from_ldap
	verify_password_method :valid_ldap_credentials?
	
	# gettext_activerecord defines a gettext method for the activerecord
	# Validations module. Authlogic uses these Validations also but does
	# not define the gettext method. We define it here instead.
	def gettext(str)
		GetText._(str)
	end 
end