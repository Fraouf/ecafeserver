class MockController < Authlogic::ControllerAdapters::AbstractAdapter
	attr_accessor :http_user, :http_password
	attr_writer :request_content_type

	def initialize
	end

	def authenticate_with_http_basic(&block)
		#yield http_user, http_password
	end

	def cookies
		#@cookies ||= MockCookieJar.new
		@cookies ||= {}
	end

	def cookie_domain
		nil
	end
	
	def logger
		#@logger ||= MockLogger.new
		@logger ||= {}
	end

	def params
		@params ||= {}
	end

	def request
		#@request ||= MockRequest.new(controller)
		@request ||= {}
	end

	def request_content_type
		@request_content_type ||= ""
	end

	def session
		@session ||= {}
	end
end
