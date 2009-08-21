require File.dirname(__FILE__) + '/../test_helper'
require 'clients_controller'

class ClientsController; def rescue_action(e) raise e end; end

class ClientsControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = ClientsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
end
