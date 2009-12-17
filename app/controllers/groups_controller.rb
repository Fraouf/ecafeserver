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

class GroupsController < ApplicationController

	before_filter :employee_required
	before_filter :admin_required, :except => [:index]
	
	def index
		@groups = Group.find :all
	end
	
	def new
		@group = Group.new
		@models = Model.find :all
	end
	
	def create
		@group = Group.new(params[:group])
		@ldap_group = LdapGroup.new
		@ldap_group.cn = @group.name
		@ldap_group.description = params[:description]
		@ldap_group.gidNumber = LdapGroup.get_next_gid
		if @group.save && @ldap_group.save
			if @group.errors.empty?
				redirect_to :controller=> "groups", :action=> "index"
				flash[:notice] = t 'groups.added_successfully'
			else
				render :action => 'new'
			end
		else
			render :action => 'new'
		end
	end
	
	def show
		@group = Group.find params[:id]
	end
	
	def edit
		@group = Group.find params[:id]
		@models = Model.find :all
	end
	
	def update
		@group = Group.find(params[:id])
		@ldapgroup = @group.ldap_entry
		@ldapgroup.description = params[:description]
		if @group.update_attributes(params[:group]) && @ldapgroup.save
			if params[:group][:model_id].nil?
				@group.update_attribute(:model_id, nil)
			end
			redirect_to :controller => "groups", :action => "edit", :id => params[:id]
			flash[:notice] = t 'groups.edit_successful'
		else
			@models = Model.find :all
			render :action => 'edit', :id => params[:id]
		end
	end
	
	def destroy
		@group = Group.find(params[:id])
		if @group && @group.name != User::ADMINS_GROUP_NAME && @group.name != User::EMPLOYEES_GROUP_NAME
			@group.destroy
			flash[:notice] = t 'groups.deleted_successfully'
			redirect_to :controller => "groups", :action => "index"
		else
			flash[:error] = t 'groups.delete_failed'
			redirect_to :controller => "groups", :action => "show", :id => @group.id
		end
	end
	
end
