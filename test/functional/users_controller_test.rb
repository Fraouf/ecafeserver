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

require 'test_helper'

class UsersControllerTest < ActionController::TestCase
	setup :activate_authlogic
	
	def test_should_create
		UserSession.create(users(:employee))
		group = groups(:students)
		assert_difference('User.count') do
			post :create, {:user => {:uid => 'testuser', :givenName => 'Test', :sn => 'User', :userPassword => 'test'}, :group => group.id}
		end
		# Need to delete user from the LDAP database
		assert_difference('User.count', -1) do
			delete :destroy, :id => User.find_by_login('testuser')
		end
		assert_redirected_to :controller => "users", :action => "index"
	end
	
	def test_employee_should_not_create_admin
		UserSession.create(users(:employee))
		group = groups(:admins)
		assert_no_difference('User.count') do
			post :create, {:user => {:uid => 'testuser', :givenName => 'Test', :sn => 'User', :userPassword => 'test'}, :group => group.id}
		end
	end
	
	def test_admin_can_create_admin
		UserSession.create(users(:admin))
		group = groups(:admins)
		assert_difference('User.count') do
			post :create, {:user => {:uid => 'testuser', :givenName => 'Test', :sn => 'User', :userPassword => 'test'}, :group => group.id}
		end
		assert_difference('User.count', -1) do
			delete :destroy, :id => User.find_by_login('testuser')
		end
	end
	
	def test_employee_can_not_update_admin
		UserSession.create(users(:employee))
		group = groups(:admins)
		post :update, {:id => users(:admin), :user => {:uid => 'admin', :givenName => 'Default', :sn => 'Admin', :userPassword => 'admin'}, :group => group.id}
		assert_template 'users/edit'
	end
	
	def test_should_update
		UserSession.create(users(:admin))
		group = groups(:employees)
		post :update, {:id => users(:employee), :user => {:uid => 'employee', :givenName => 'Default', :sn => 'Employee', :userPassword => 'admin'}, :group => group.id}
		assert_redirected_to :controller => "users", :action => "index"
	end
	
	def test_employee_can_not_destroy_admin
		UserSession.create(users(:employee))
		assert_no_difference('User.count') do
			delete :destroy, :id => User.find_by_login('admin')
		end
		assert_template 'users/show'
	end
		
end
