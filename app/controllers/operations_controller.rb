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

class OperationsController < ApplicationController
	before_filter :admin_required
	
	def index
		if(params[:operation_type].nil?)
			@operations = Operation.paginate :page => params[:page], :order => "created_at DESC"
			@date_from = Date.today
			@date_to = @date_from + 1.day
		else
			@date_from = Date.civil(params[:range][:"from(1i)"].to_i,params[:range][:"from(2i)"].to_i,params[:range][:"from(3i)"].to_i)
			@date_to = Date.civil(params[:range][:"to(1i)"].to_i,params[:range][:"to(2i)"].to_i,params[:range][:"to(3i)"].to_i)
			@user = params[:user]
			@operation_type = params[:operation_type]
			if(@user == '')
				if(@operation_type == "operations.all")
					conditions = ["created_at >= ? AND created_at <= ?", @date_from, @date_to]
				else
					conditions = ["created_at >= ? AND created_at <= ? AND operation_type = ?", @date_from, @date_to, @operation_type]
				end
			else
				if(@operation_type == "operations.all")
					conditions = ["user = ? AND created_at >= ? AND created_at <= ?", @user, @date_from, @date_to]
				else
					conditions = ["user = ? AND created_at >= ? AND created_at <= ? AND operation_type = ?", @user, @date_from, @date_to, @operation_type]
				end
			end
			@operations = Operation.paginate :page => params[:page], :order => "created_at DESC", :conditions => conditions
		end
	end
end
