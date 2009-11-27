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

class GroupsControllerTest < ActionController::TestCase
	setup :activate_authlogic
	
	def test_should_get_index
		UserSession.create(users(:employee))
		get :index
		assert_response :success
		assert_not_nil assigns(:groups)
	end
	
	def test_should_redirect_index
		get :index
		assert_response :redirect
	end
	
	def test_should_create_group
		UserSession.create(users(:admin))
		assert_difference('Group.count') do
			post :create, {:group => { :name => 'test', :price => 0, :storage => 50}, :description => "test group"}
		end
		# Need to delete the group from the LDAP database
		group = Group.find_by_name('test')
		delete :destroy, :id => group.id
		assert_redirected_to :controller => "groups", :action => "index"
	end
	
	def test_should_not_create_group
		UserSession.create(users(:employee))
		assert_no_difference('Group.count') do
			post :create, {:group => { :name => 'test', :price => 0, :storage => 50}, :description => "test group"}
		end
	end
	
	def test_should_update
		UserSession.create(users(:admin))
		group = groups(:students)
		post :update, {:id => group.id, :group => { :name => 'students', :price => 0, :storage => 60}, :description => "Students group"}
		assert_redirected_to :controller => "groups", :action => "edit", :id => group.id
	end
	
	def test_should_not_update
		UserSession.create(users(:employee))
		group = groups(:students)
		post :update, {:id => group.id, :group => { :name => 'students', :price => 0, :storage => 60}, :description => "Students group"}
		assert_response :redirect
	end
	
	def test_should_not_update_with_invalid_price
		UserSession.create(users(:admin))
		group = groups(:students)
		post :update, {:id => group.id, :group => { :name => 'students', :price => -1, :storage => 60}, :description => "Students group"}
		assert_template 'groups/edit'
	end
	
	def test_should_not_update_with_invalid_storage
		UserSession.create(users(:admin))
		group = groups(:students)
		post :update, {:id => group.id, :group => { :name => 'students', :price => 0, :storage => -1}, :description => "Students group"}
		assert_template 'groups/edit'
	end
end
