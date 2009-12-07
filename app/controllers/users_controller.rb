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

class UsersController < ApplicationController
	before_filter :employee_required
	
	def index
		@users = User.find :all
	end
	
	def show
		@user = User.find(params[:id])
	end
	
	def new
		@user = LdapUser.new
		@groups = Group.find :all		
	end
	
	def create
		# DB user
		@db_user = User.new
		@db_user.login = params[:user][:uid]
		# LDAP user
		@user = LdapUser.new(params[:user])
		@db_group = Group.find(params[:group])
		@group = @db_group.ldap_entry
		@groups = Group.find :all
		if authorize_employee(@group.cn, 'new')
			@user.gid_number = @group.gidNumber
			@user.cn = @user.givenName + ' ' + @user.sn
			@user.uid_number = LdapUser.get_next_uid
			@user.home_directory = "/home/" + params[:user][:uid]
			@user.loginShell = "/bin/bash"
			if @db_group.name == User::ADMINS_GROUP_NAME || @db_group.name == User::EMPLOYEES_GROUP_NAME
				# Unlimited quotas for admins and employees
				@user.quota = APP_CONFIG['qpartition'] + ":0:0:0:0"
			else
				soft_limit = @db_group.storage * APP_CONFIG['block_size']
				hard_limit = (@db_group.storage + 50) * APP_CONFIG['block_size']
				@user.quota = APP_CONFIG['qpartition'] + ":" + soft_limit.to_s() + ":" + hard_limit.to_s() + ":0:0"
			end
			if @user.save && @db_user.save
				@group.members << @user
				if @user.errors.empty?
					if @db_group.model
						@timecode = Timecode.new_from_model(@db_group.model)
						@timecode.user = @db_user
						@timecode.save
					end
					unless @db_user.is_admin? || @db_user.is_employee?
						sale = Sale.new(:amount => @db_group.price, :user_id => @db_user.id)
						sale.save
					end
					redirect_to :controller => "users", :action => "index"
					flash[:notice] = t 'users.added_successfully'
				else
					render :action => 'new'
				end
			else
				render :action => 'new'
				logger.debug(@user.errors.full_messages)
			end
		end
	end
	
	def edit_profile
		@user = current_user
	end
	
	def update_profile
		@user = current_user
		@ldapuser = @user.ldap_entry
		@ldapuser.givenName = params[:user][:givenName]
		@ldapuser.sn = params[:user][:sn]
		@ldapuser.cn = params[:user][:givenName] + ' ' + params[:user][:sn]
		if(params[:user][:userPassword] != '')
			@ldapuser.userPassword = params[:user][:userPassword]
		end
		@ldapuser.mail = params[:user][:mail]
		@ldapuser.homePhone = params[:user][:homePhone]
		if @ldapuser.save
			redirect_to :controller => "users", :action => "edit_profile"
			flash[:notice] = t 'users.edit_successful'
		else
			render :action => 'edit'
		end
	end

	def edit
		@user = User.find(params[:id])
		@groups = LdapGroup.find :all
	end

	def update
		@user = User.find(params[:id])
		@ldapuser = @user.ldap_entry
		@groups = LdapGroup.find :all
		if authorize_employee(@ldapuser.group, 'edit')
			@ldapuser.givenName = params[:user][:givenName]
			@ldapuser.sn = params[:user][:sn]
			@ldapuser.cn = params[:user][:givenName] + ' ' + params[:user][:sn]
			if(params[:user][:userPassword] != '')
				@ldapuser.userPassword = params[:user][:userPassword]
			end
			@ldapuser.mail = params[:user][:mail]
			@ldapuser.homePhone = params[:user][:homePhone]
			if @ldapuser.save
				redirect_to :controller => "users", :action => "index"
				flash[:notice] = t 'users.edit_successful'
			else
				render :action => 'edit'
			end
		end
	end
	
	def destroy
		@user = User.find(params[:id])
		if @user && authorize_employee(@user.ldap_entry.group, 'show')
			@user.ldap_entry.destroy
			@user.destroy
			flash[:notice] = t 'users.deleted_successfully'
			redirect_to :controller => "users", :action => "index"
		end
	end
	
	def new_credit
		@models = Model.find(:all)
		@user = User.find(params[:id])
	end

	def create_credit
		@user = User.find(params[:id])
		@models = Model.find(:all)
		if authorize_employee(@user.ldap_entry.group, 'new_credit')
			@model = Model.find_by_id(params[:model][:id])
			if @model
				@timecode = Timecode.new_from_model(@model)
				if @user
					@timecode.user = @user
					if @timecode.save
						flash[:notice] = I18n.t('timecodes.added_successfully', :code => @timecode.code)
						redirect_to :controller => "users", :action => "show", :id => @user.id
					else
						flash[:error] = t 'timecodes.add_failed'
						redirect_to :controller => "users", :action => "new_credit", :id => @user.id
					end
				end
			end
		end
	end
	
	private
	
	def authorize_employee(user_group, action)
		if(user_group == User::ADMINS_GROUP_NAME && current_user.is_employee?)
			flash[:error] = t 'sessions.admin_required'
			render :action => action
			return false
		else
			return true
		end
	end
end
