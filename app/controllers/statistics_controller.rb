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

class StatisticsController < ApplicationController
  before_filter :employee_required

  def index
    if(params[:commit].nil?)
      @date = Date.today
    else
      @date = Date.civil(params[:range][:"from(1i)"].to_i,params[:range][:"from(2i)"].to_i,params[:range][:"from(3i)"].to_i)
    end
    @time = @date.midnight
    @day_amount = 0
    Sale.find_each(:conditions => { :created_at => (@time)..(@time + 1.day) }) do |sale|
      @day_amount += sale.amount
    end
    @day_timecodes = Timecode.count(:conditions => { :created_at => (@time)..(@time + 1.day) })
    @day_customers = Customer.count(:conditions => { :created_at => (@time)..(@time + 1.day) })
  end

end
