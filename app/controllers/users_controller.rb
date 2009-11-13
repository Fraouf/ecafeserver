class UsersController < ApplicationController
	def index
		@users = LdapUser.find :all
	end
	
	def new
		@user = LdapUser.new
		@groups = LdapGroup.find :all
			
	end
	
	def create
		@user = LdapUser.new(params[:user])
		@group = LdapGroup.find(params[:group])
		@user.gid_number = @group.gidNumber
		@user.cn = @user.givenName + ' ' + @user.sn
    	@user.uid_number = get_ldap_uid()
    	@user.home_directory = "/home/" + params[:user][:uid]
    	@user.loginShell = "/bin/bash"
		# Unlimited quotas for employees
		@user.quota = APP_CONFIG['qpartition'] + ":0:0:0:0"
		if @user.save
			@group.members << @user
			if @user.errors.empty?
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

	def edit
		@user = current_user
	end

	def update
		@user = current_user
		if @user.update_attributes(params[:user])
			flash[:notice] = "Successfully updated profile."
			redirect_to root_url
		else
			render :action => 'edit'
		end
	end
	
	def destroy
		if LdapUser.exists?(params[:id])
			LdapCustomer.destroy(params[:id])
			flash[:notice] = t 'users.deleted_successfully'
			redirect_to :controller => "users", :action => "index"
		end
	end

end
