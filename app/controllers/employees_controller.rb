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

class EmployeesController < ApplicationController
	before_filter :employee_required
	before_filter :admin_required, :except => [:edit_profile, :update_profile]
	
	def index
		@employees = Employee.find(:all)
	end
  
	# render new.rhtml
	def new
		@employee = Employee.new
	end

	def create
		@employee = Employee.new(params[:employee])
		success = @employee && @employee.save
		if success && @employee.errors.empty?
		  redirect_to :controller => "employees", :action => "index"
		  flash[:notice] = t 'employees.added_successfully'
		else
		  render :action => 'new'
		end
	end
	
	def destroy
		@employee = Employee.find_by_id(params[:id])
		if @employee
			@employee.destroy
			flash[:notice] = t 'employees.deleted_successfully'
			redirect_to :controller => "employees", :action => "index"
		end
	end
	
	def edit
		@employee = Employee.find_by_id(params[:id])
	end
	
	def update
		@employee = Employee.find_by_id(params[:id])
		if @employee.update_attributes(params[:employee])
			redirect_to :controller => "employees", :action => "index"
			flash[:notice] = t 'employees.edit_successful'
		else
			render :action => 'edit'
		end
	end
	
	def edit_profile
		@employee = current_employee
	end
	
	def update_profile
		if current_employee.update_attributes(params[:employee])
			redirect_to :controller => "employees", :action => "edit_profile"
			flash[:notice] = t 'employees.edit_profile_successful'
		else
			render :action => 'edit_profile'
		end
	end
	
end
