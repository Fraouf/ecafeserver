class UsersController < ApplicationController
	def index
		@users = User.find :all
	end
	
	def new
		@user = LdapUser.new
		@groups = LdapGroup.find :all
			
	end
	
	def create
		# DB user
		@user = User.new
		@user.login = params[:user][:uid]
		# LDAP user
		@ldapuser = LdapUser.new(params[:user])
		@group = LdapGroup.find(params[:group])
		@ldapuser.gid_number = @group.gidNumber
		@ldapuser.cn = @ldapuser.givenName + ' ' + @ldapuser.sn
    	@ldapuser.uid_number = get_ldap_uid()
    	@ldapuser.home_directory = "/home/" + params[:user][:uid]
    	@ldapuser.loginShell = "/bin/bash"
		# Unlimited quotas for employees
		@ldapuser.quota = APP_CONFIG['qpartition'] + ":0:0:0:0"
		if @ldapuser.save && @user.save
			@group.members << @ldapuser
			if @ldapuser.errors.empty?
				redirect_to :controller => "users", :action => "index"
				flash[:notice] = t 'users.added_successfully'
			else
				render :action => 'new'
			end
		else
			render :action => 'new'
			logger.debug(@ldapuser.errors.full_messages)
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
	
	def destroy
		@user = User.find(params[:id])
		if @user
			@user.ldap_entry.destroy
			@user.destroy
			flash[:notice] = t 'users.deleted_successfully'
			redirect_to :controller => "users", :action => "index"
		end
	end

end
