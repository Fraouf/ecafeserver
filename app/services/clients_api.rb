class ClientStatus < ActionWebService::Struct
  member :state,      :string
  member :type,       :string
end

class ClientsApi < ActionWebService::API::Base
	api_method :register, :expects => [ {:port => :integer},
                                      {:hostname => :string}], :returns => [:string]
  api_method :unregister, :expects => [{:session_id => :string}]
  api_method :status, :expects => [{:session_id => :string}], :returns => [ClientStatus]
  api_method :get_timecode, :expects => [{:session_id => :string}], :returns => [Timecode]
  api_method :get_customer, :expects => [{:session_id => :string}], :returns => [Customer]
  api_method :connect_customer, :expects=> [{:session_id => :string},
                                            {:login => :string},
                                            {:password => :string}], :returns => [:boolean]
  api_method :connect_timecode, :expects => [{:session_id => :string},
                                             {:code => :string}], :returns => [:boolean]
  api_method :disconnect, :expects => [{:session_id => :string}], :returns => [:boolean]
  api_method :decrement_time, :expects => [{:session_id => :string}], :returns => [:integer]
end
