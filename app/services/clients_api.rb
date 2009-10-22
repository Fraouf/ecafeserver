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

class ClientStatus < ActionWebService::Struct
  member :state,      :string
  member :type,       :string
end

class ClientCustomer < ActionWebService::Struct
  member  :name,    :string
  member  :email,   :string
  member  :phone,   :string
  member  :login,   :string
  member  :time,    :integer
  member  :created_at,   :datetime
  member  :last_login_at,  :datetime

end

class ClientsApi < ActionWebService::API::Base
	api_method :register, :expects => [ {:port => :integer},
                                      {:hostname => :string}], :returns => [:string]
  api_method :unregister, :expects => [{:session_id => :string}]
  api_method :status, :expects => [{:session_id => :string}], :returns => [ClientStatus]
  api_method :get_timecode, :expects => [{:session_id => :string}], :returns => [Timecode]
  api_method :get_customer, :expects => [{:session_id => :string}], :returns => [ClientCustomer]
  api_method :connect_customer, :expects=> [{:session_id => :string},
                                            {:login => :string},
                                            {:password => :string}], :returns => [:boolean]
  api_method :connect_timecode, :expects => [{:session_id => :string},
                                             {:code => :string}], :returns => [:boolean]
  api_method :disconnect, :expects => [{:session_id => :string}], :returns => [:boolean]
  api_method :decrement_time, :expects => [{:session_id => :string}], :returns => [:integer]
end
