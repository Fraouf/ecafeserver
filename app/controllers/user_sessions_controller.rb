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

class UserSessionsController < ApplicationController
	before_filter :require_no_user, :except => [:destroy]
	
	def new
		@user_session = UserSession.new()
	end
	
	def create
		@user_session = UserSession.new(params[:user_session])
		if @user_session.save
			flash[:notice] = t 'sessions.login_successful'
			redirect_back_or_default url_for(:controller => "pages", :action => "index")
		else
			flash[:error] = t('sessions.login_failed')
			render :action => 'new'
		end
	end

	def destroy
		@user_session = UserSession.find
		@user_session.destroy
		flash[:notice] = t 'sessions.logout'
		redirect_to root_url
	end

end
