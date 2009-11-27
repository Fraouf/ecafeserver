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

class TimecodesControllerTest < ActionController::TestCase
	setup :activate_authlogic
	
	def test_should_get_index
		UserSession.create(users(:employee))
		get :index
		assert_response :success
	end
	
	def test_should_create_timecode
		UserSession.create(users(:employee))
		assert_difference('Timecode.count') do
			post :create, :model => models(:one_hour)
		end
	end
	
	def test_should_not_create_timecode
		UserSession.create(users(:employee))
		assert_no_difference('Timecode.count') do
			post :create, :model => { :id => 1000 }
		end
	end
	
	def test_should_have_flash_error
		UserSession.create(users(:employee))
		post :create, :model => { :id => 1000}
		assert_not_nil flash[:error]
	end
	
	def test_should_redirect_to_index
		UserSession.create(users(:employee))
		post :create, :model => { :id => 1000 }
		assert_redirected_to :controller => "timecodes", :action => "index"
	end
	
	def test_should_destroy
		UserSession.create(users(:admin))
		assert_difference('Timecode.count', -1) do
			delete :destroy, :id => timecodes(:onehour)
		end
	end
	
	def test_should_not_be_destroyed_by_employee
		UserSession.create(users(:employee))
		assert_no_difference('Timecode.count') do
			delete :destroy, :id => timecodes(:can_not_be_destroyed_by_employee)
		end
	end
		
end
