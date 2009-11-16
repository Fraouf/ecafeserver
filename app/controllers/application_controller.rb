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

class ApplicationController < ActionController::Base
	# locale stuff
	before_filter :set_locale
	def available_locales; AVAILABLE_LOCALES; end
	def set_locale
		# if params[:locale] is nil then I18n.default_locale will be used
		I18n.default_locale = locale()
		I18n.locale = I18n.default_locale
	end

	filter_parameter_logging :password

	helper :all # include all helpers, all the time
	protect_from_forgery # See ActionController::RequestForgeryProtection for details

	helper_method :is_admin?
	helper_method :current_user

	# Scrub sensitive parameters from your log
	# filter_parameter_logging :password
	protected

	# Returns true if the current user is an admin
	def is_admin?
		current_user.is_admin?
	end

	# Redirects the user if he is not an adminitrator
	def admin_required
		if current_user
			is_admin? || access_denied
		else
			access_denied
		end
	end

	# Returns the locale
	def locale
		config = Configuration.instance
		return config.locale
	end
	
	# Returns the next available ldap uid
	def get_ldap_uid()
		uids = ActiveLdap::Base.search(:base => 'ou=People,dc=ecafe,dc=org', :filter => 'uidNumber=*', :attributes => [ 'uidNumber'])
		max_uid = 1100
		uids.each do |uid_array|
			uid = uid_array[1]['uidNumber'][0]
			if uid.to_i > max_uid
				max_uid = uid.to_i
			end
		end
		return max_uid + 1
	end

	private

	# Returns the current user session
	def current_user_session
		return @current_user_session if defined?(@current_user_session)
		@current_user_session = UserSession.find
	end

	# Returns the currently logged in user
	def current_user
		return @current_user if defined?(@current_user)
		@current_user = current_user_session && current_user_session.record
	end
	
	# Redirects the user if he is not an employee
	def employee_required
		if current_user
			current_user.is_admin? || current_user.is_employee? || access_denied
		else
			access_denied
		end
	end

	# Redirects the user to the index page if he is logged in
	def require_no_user
		if current_user
			redirect_to :controller => "pages", :action => "index"
		end
	end
	
	private
	
	def access_denied
		store_location
		flash[:notice] = t 'sessions.access_denied'
		redirect_to new_user_session_url
	end
	
	def store_location
		session[:return_to] = request.request_uri
	end
	
	def redirect_back_or_default(default)
		redirect_to(session[:return_to] || default)
		session[:return_to] = nil
	end
	
end
