require File.dirname(__FILE__) + '/../test_helper'
require 'clients_controller'

class ClientsController; def rescue_action(e) raise e end; end

class ClientsControllerApiTest < Test::Unit::TestCase
	def setup
		@controller = ClientsController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
	end

	def test_register
		result = invoke :register, 65536, "toto"
		assert_instance_of String, result
	end
	
	def test_status_invalid
		assert_raise XMLRPC::FaultException do
			result = invoke :status, '123'
		end
	end
	
#	def test_should_get_available
#		result = invoke :status, "dbf8ec26-76f3-11de-9464-00247e13e797"
#		assert_instance_of ClientStatus, result
#		assert_equal result["state"], "available"
#	end
	
#	def test_should_get_session_id
#		assert_difference('Client.count') do
#			#post (:register, {'port' => 65536} , {'hostname' => "toto"})
#			post :register, {'port' => 65536}
#		end
#	end
	
#	def test_should_get_null
#		get :status, :session_id => '123'
#		rsp = assigns(:rsp)
#		assert_equal(rsp["success"], false)
#		assert_equal(rsp["message"], "clients.not_found")
#	end

#	def test_should_get_available
#		get :status, :session_id => 'dbf8ec26-76f3-11de-9464-00247e13e797'
#		rsp = assigns(:rsp)
#		client = assigns(:client)
#		assert_equal(rsp["state"], "available")
#		assert_not_nil(client.last_request)
#	end

#	def test_should_get_user
#		get :status, :session_id => 'a40191f2-76f7-11de-9464-00247e13e797'
#		rsp = assigns(:rsp)
#		assert_equal(rsp["type"], "user")
#		assert(rsp["user"].is_a?(ClientUser))
#	end

#	def test_should_get_timecode
#		get :status, :session_id => 'a3905e42-76f7-11de-9464-00247e13e797'
#		rsp = assigns(:rsp)
#		assert_equal(rsp["type"], "timecode")
#		assert(rsp["timecode"].is_a?(Timecode))
#	end

#	def test_connect_user_invalid_login
#		get :connect_user, {:session_id => 'dbf8ec26-76f3-11de-9464-00247e13e797', :login => 'guillau', :password => 'toto'}
#		rsp = assigns(:rsp)
#		assert_equal(rsp["message"], "users.login_not_found")
#	end

#	def test_connect_user_invalid_password
#		get :connect_user, {:session_id => 'dbf8ec26-76f3-11de-9464-00247e13e797', :login => 'guillaume', :password => 'toto'}
#		rsp = assigns(:rsp)
#		assert_equal(rsp["message"], "users.password_invalid")
#	end

#	def test_connect_user_no_time_left
#		get :connect_user, {:session_id => 'dbf8ec26-76f3-11de-9464-00247e13e797', :login => 'guillaume', :password => 'guillaume'}
#		rsp = assigns(:rsp)
#		assert_equal(rsp["message"], "users.no_time_left")
#	end

#	def test_should_connect_user
#		get :connect_user, {:session_id => 'dbf8ec26-76f3-11de-9464-00247e13e797', :login => 'guillaume2', :password => 'guillaume'}
#		rsp = assigns(:rsp)
#		assert_equal(rsp["success"], true)
#	end

#	def test_connect_timecode_not_found
#		get :connect_timecode, {:session_id => 'dbf8ec26-76f3-11de-9464-00247e13e797', :code => 'abcdefgh'}
#		rsp = assigns(:rsp)
#		assert_equal(rsp["message"], "timecodes.not_found")
#	end

#	def test_connect_timecode_invalid
#		get :connect_timecode, {:session_id => 'dbf8ec26-76f3-11de-9464-00247e13e797'}, {:code => '578f9958'}
#		rsp = assigns(:rsp)
#		assert_equal(rsp["message"], "timecodes.invalid")
#	end

#	def test_connect_timecode_valid
#		get :connect_timecode, {:session_id => 'dbf8ec26-76f3-11de-9464-00247e13e797', :code => '578f9959'}
#		rsp = assigns(:rsp)
#		assert_equal(rsp["success"], true)
#	end

#	def test_disconnect_timecode
#		get :disconnect, {:session_id => 'a3905e42-76f7-11de-9464-00247e13e797'}
#		rsp = assigns(:rsp)
#		assert_equal(rsp["success"], true)
#		client = assigns(:client)
#		assert_equal(client.state, "available")
#	end

#	def test_disconnect_user
#		get :disconnect, {:session_id => 'a40191f2-76f7-11de-9464-00247e13e797'}
#		rsp = assigns(:rsp)
#		assert_equal(rsp["success"], true)
#		client = assigns(:client)
#		assert_equal(client.state, "available")
#	end

end
