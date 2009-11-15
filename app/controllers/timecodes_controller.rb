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

class TimecodesController < ApplicationController
	before_filter :employee_required
	
	def index
		if(params[:q].nil?)
			@timecodes = Timecode.paginate :conditions => ["user_id IS NULL"], :page => params[:page], :order => "created_at DESC"
		else
			@timecodes = Timecode.paginate :conditions => ["user_id IS NULL AND code LIKE ?",  params[:q] + "%"], :page => params[:page], :order => "created_at DESC"
		end
	end
	
	def new
		@models = Model.find(:all)
	end
	
	def create
		@model = Model.find_by_id(params[:model][:id])
		if @model
			@timecode = Timecode.new_from_model(@model)
			if @timecode.save
				flash[:notice] = I18n.t('timecodes.added_successfully', :code => @timecode.code)
				redirect_to :controller => "timecodes", :action => "index"
			else
				flash[:error] = t 'timecodes.add_failed'
				redirect_to :controller => "timecodes", :action => "index"
			end
		end
	end
	
	def destroy
		@timecode = Timecode.find_by_id(params[:id])
		if @timecode
			code = @timecode.code
			user_id = @timecode.user_id
			if current_user.is_admin # The employee is an admin, he can delete whatever he wants
				destroy_sale(@timecode) if @timecode.created_at == @timecode.updated_at
				@timecode.destroy
				destroy_success(code, user_id)
			else #The employee is a basic employee, he can delete timecodes that have never been used only
				if @timecode.created_at == @timecode.updated_at
					# Destroy sale associated with timecode
					destroy_sale(@timecode)
					@timecode.destroy
					destroy_success(code, user_id)
				else
					Operation.add("operations.administration", "operations.timecode", "operations.destroy", "operations.timecodes.destroy_failed, " + code)
					flash[:error] = t 'timecodes.destroy_failed'
					if (user_id.nil?)
						redirect_to :controller => "timecodes", :action => "index"
					else
						redirect_to :controller => "users", :action => "show", :id => user_id
					end
				end
			end
		end
	end
	
	protected
	
	def destroy_success (code, user_id)
		flash[:notice] = I18n.t('timecodes.destroyed_successfully', :code => code)
		if user_id.nil?
			redirect_to :controller => "timecodes", :action => "index"
		else
			redirect_to :controller => "users", :action => "show", :id => user_id
		end
	end

	def destroy_sale(timecode)
		sale = Sale.find_by_timecode_id(timecode.id)
		sale.destroy unless sale.nil?
	end
		
end
