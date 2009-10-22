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

  before_filter :set_request_environment
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include AuthenticatedSystem
  
  helper_method :is_admin?
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
  
  def is_admin?
	current_employee.is_admin
  end
  
  def admin_required
	is_admin? || access_denied
  end
  
  def locale
	config = Configuration.instance
	return config.locale
  end

  private
  def set_request_environment
    Employee.current = current_employee unless current_employee == nil
  end
end
