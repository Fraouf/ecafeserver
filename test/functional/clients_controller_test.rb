require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
 def test_should_get_session_id
   assert_difference('Client.count') do
    post :create, :client => {:ip_address => '192.168.1.7', :hostname => "toto", :port => '65536'}
   end
 end

 def test_should_get_null
   get :status, :session_id => '123'
   rsp = assigns(:rsp)
   assert_equal(rsp["success"], false)
   assert_equal(rsp["message"], "clients.not_found")
 end

 def test_should_get_available
   get :status, :session_id => 'dbf8ec26-76f3-11de-9464-00247e13e797'
   rsp = assigns(:rsp)
   client = assigns(:client)
   assert_equal(rsp["state"], "available")
   assert_not_nil(client.last_request)
 end

 def test_should_get_customer
   get :status, :session_id => 'a40191f2-76f7-11de-9464-00247e13e797'
   rsp = assigns(:rsp)
   assert_equal(rsp["type"], "customer")
   assert(rsp["customer"].is_a?(Customer))
 end

 def test_should_get_timecode
   get :status, :session_id => 'a3905e42-76f7-11de-9464-00247e13e797'
   rsp = assigns(:rsp)
   assert_equal(rsp["type"], "timecode")
   assert(rsp["timecode"].is_a?(Timecode))
 end

 def test_connect_customer_invalid_login
   get :connect_customer, {:session_id => 'dbf8ec26-76f3-11de-9464-00247e13e797', :login => 'guillau', :password => 'toto'}
   rsp = assigns(:rsp)
   assert_equal(rsp["message"], "customers.login_not_found")
 end

 def test_connect_customer_invalid_password
   get :connect_customer, {:session_id => 'dbf8ec26-76f3-11de-9464-00247e13e797', :login => 'guillaume', :password => 'toto'}
   rsp = assigns(:rsp)
   assert_equal(rsp["message"], "customers.password_invalid")
 end

 def test_connect_customer_no_time_left
   get :connect_customer, {:session_id => 'dbf8ec26-76f3-11de-9464-00247e13e797', :login => 'guillaume', :password => 'guillaume'}
   rsp = assigns(:rsp)
   assert_equal(rsp["message"], "customers.no_time_left")
 end

 def test_should_connect_customer
   get :connect_customer, {:session_id => 'dbf8ec26-76f3-11de-9464-00247e13e797', :login => 'guillaume2', :password => 'guillaume'}
   rsp = assigns(:rsp)
   assert_equal(rsp["success"], true)
 end

 def test_connect_timecode_not_found
   get :connect_timecode, {:session_id => 'dbf8ec26-76f3-11de-9464-00247e13e797', :code => 'abcdefgh'}
   rsp = assigns(:rsp)
   assert_equal(rsp["message"], "timecodes.not_found")
 end

 def test_connect_timecode_invalid
   get :connect_timecode, {:session_id => 'dbf8ec26-76f3-11de-9464-00247e13e797', :code => '578f9958'}
   rsp = assigns(:rsp)
   assert_equal(rsp["message"], "timecodes.invalid")
 end

 def test_connect_timecode_valid
   get :connect_timecode, {:session_id => 'dbf8ec26-76f3-11de-9464-00247e13e797', :code => '578f9959'}
   rsp = assigns(:rsp)
   assert_equal(rsp["success"], true)
 end

 def test_disconnect_timecode
   get :disconnect, {:session_id => 'a3905e42-76f7-11de-9464-00247e13e797'}
   rsp = assigns(:rsp)
   assert_equal(rsp["success"], true)
   client = assigns(:client)
   assert_equal(client.state, "available")
 end

 def test_disconnect_customer
   get :disconnect, {:session_id => 'a40191f2-76f7-11de-9464-00247e13e797'}
   rsp = assigns(:rsp)
   assert_equal(rsp["success"], true)
   client = assigns(:client)
   assert_equal(client.state, "available")
 end
end
