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

class SalesController < ApplicationController
	before_filter :employee_required

	def index
		if(params[:commit].nil?)
			@sales = Sale.paginate :page => params[:page], :order => "created_at DESC"
			@date_from = Date.today
			@date_to = @date_from + 1.day
		else
			@date_from = Date.civil(params[:range][:"from(1i)"].to_i,params[:range][:"from(2i)"].to_i,params[:range][:"from(3i)"].to_i)
			@date_to = Date.civil(params[:range][:"to(1i)"].to_i,params[:range][:"to(2i)"].to_i,params[:range][:"to(3i)"].to_i)
			conditions = ["created_at >= ? AND created_at <= ?", @date_from, @date_to]
			@sales = Sale.paginate :page => params[:page], :order => "created_at DESC", :conditions => conditions
		end
	end
end
