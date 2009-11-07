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

class CustomersController < ApplicationController
  before_filter :login_required
  
  def new
    @customer = LdapCustomer.new
  end

  def index
    #if(params[:q].nil?)
    #  @customers = LdapCustomer.paginate :page => params[:page], :order => "created_at DESC"
    #else
    #  @customers = LdapCustomer.paginate :conditions => ["login LIKE ?",  params[:q].concat("%")], :page => params[:page], :order => "created_at DESC"
    #end
    @customers = Customer.find(:all)
  end

  def show
    @customer = Customer.find(params[:id])
    @ldap_customer = @customer.ldap_customer
  end

  def create
		@db_customer = Customer.new
    @db_customer.uid = params[:customer][:uid]
    @customer = LdapCustomer.new(params[:customer])
    @customer.cn = @customer.givenName + ' ' + @customer.sn
    @customer.gid_number = 1100
    @customer.uid_number = get_uid()
    @customer.home_directory = "/home/" + params[:customer][:uid]
    @customer.loginShell = "/bin/bash"
    # Format of the quota attribute:
    # Partition:Soft limit in blocks:Hard limit in blocks:Soft limit in files:Hard limit in files
    # 40960 blocks = 10 MB on a filesystem which has 4096 as the block size
    @customer.quota = "/dev/sda1:204800:245760:0:0"
    @group = LdapGroup.find("customers")
    if @customer.save
      success = @db_customer && @db_customer.save
      @group.members << @customer
      if success && @customer.errors.empty?
        redirect_to :controller => "customers", :action => "index"
        flash[:notice] = t 'customers.added_successfully'
      else
        render :action => 'new'
      end
    else
      render :action => 'new'
      logger.debug(@customer.errors.full_messages)
    end
	end

  def edit
    @db_customer = Customer.find(params[:id])
    @customer = LdapCustomer.find(@db_customer.uid)
  end

  def update
    @db_customer = Customer.find(params[:id])
    @customer = LdapCustomer.find(@db_customer.uid)
    @customer.givenName = params[:customer][:givenName]
    @customer.sn = params[:customer][:sn]
    @customer.cn = params[:customer][:givenName] + ' ' + params[:customer][:sn]
    if(params[:customer][:userPassword] != '')
      @customer.userPassword = params[:customer][:userPassword]
    end
    @customer.mail = params[:customer][:mail]
    @customer.homePhone = params[:customer][:homePhone]
    if @customer.save
      redirect_to :controller => "customers", :action => "index"
      flash[:notice] = t 'customers.edit_successful'
    else
      render :action => 'edit'
    end
	end

  def destroy
		@customer = Customer.find(params[:id])
		if @customer
      if LdapCustomer.exists?(@customer.uid)
        LdapCustomer.destroy(@customer.uid)
      end
			@customer.destroy
			flash[:notice] = t 'customers.deleted_successfully'
			redirect_to :controller => "customers", :action => "index"
		end
	end

  def new_credit
    @models = Model.find(:all)
    @customer = Customer.find(params[:id])
  end
  
  def create_credit
    @model = Model.find_by_id(params[:model][:id])
    if @model
			@timecode = Timecode.new_from_model(@model)
      @customer = Customer.find(params[:id])
      if @customer
        @timecode.customer = @customer
        if @timecode.save
          flash[:notice] = I18n.t('timecodes.added_successfully', :code => @timecode.code)
          redirect_to :controller => "customers", :action => "show", :id => @customer.id
        else
          flash[:error] = t 'timecodes.add_failed'
          redirect_to :controller => "customers", :action => "new_credit", :id => @customer.id
        end
      end
		end
  end

  protected
  def get_uid()
    uids = ActiveLdap::Base.search(:base => 'ou=People,dc=ecafe,dc=org', :filter => 'uidNumber=*', :attributes => [ 'uidNumber'])
    max_uid = 1100
    uids.each do |uid_array|
      uid = uid_array[1]['uidNumber'][0]
      if uid.to_i > max_uid
        max_uid = uid.to_i
      end
    end
    return max_uid + 1
  end
end
