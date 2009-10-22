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

class ClientsController < ApplicationController

  layout nil
  
  wsdl_service_name 'Clients'
  web_service_api ClientsApi
  web_service_scaffold :invocation if Rails.env == 'development'
  
  def register(port, hostname)
    ip_address = determine_ip(request)
    client_found = Client.find_by_ip_address(ip_address)
    if !client_found.nil?
      raise XMLRPC::FaultException.new(-1, "IP Address already registered")
    else
      client = Client.new(:ip_address => ip_address, :port => port, :hostname => hostname)
      success = client && client.save
      if success
        return client.session_id
      else
        raise XMLRPC::FaultException.new(-2, "Invalid parameters")
      end
    end
  end

  def unregister(session_id)
    @client = Client.find_by_session_id(session_id)
    if @client
      @client.destroy
    else
      raise XMLRPC::FaultException.new(-3, "Client not found")
    end
  end

  def status(session_id)
    @client = Client.find_by_session_id(session_id)
    @rsp = ClientStatus.new
    if @client.nil?
      raise XMLRPC::FaultException.new(-3, "Client not found")
    else
      @rsp.state = @client.state
      if @client.state == "connected"
        @rsp.type = @client.type()
      end
      @client.update_attribute("last_request", Time.now)
    end
    return @rsp
  end

  def get_timecode(session_id)
    @client = Client.find_by_session_id(session_id)
    if @client.nil?
      raise XMLRPC::FaultException.new(-3, "Client not found")
    else
      if @client.state == "connected" && @client.type() == "timecode"
        return @client.timecode
      else
        raise XMLRPC::FaultException.new(-11, "Client must be connected with a timecode")
      end
      @client.update_attribute("last_request", Time.now)
    end
  end

  def get_customer(session_id)
    @client = Client.find_by_session_id(session_id)
    if @client.nil?
      raise XMLRPC::FaultException.new(-3, "Client not found")
    else
      if @client.state == "connected" && @client.type() == "customer"
        @customer = @client.customer
        @clientcustomer = ClientCustomer.new
        @clientcustomer.name = @customer.ldap_customer.givenName
        @clientcustomer.email = @customer.ldap_customer.mail
        @clientcustomer.phone = @customer.ldap_customer.homePhone
        @clientcustomer.login = @customer.uid
        @clientcustomer.last_login_at = @customer.last_login_at
        @clientcustomer.created_at = @customer.created_at
        @clientcustomer.time = @customer.time
        return @clientcustomer
      else
        raise XMLRPC::FaultException.new(-12, "Client must be connected with a customer")
      end
      @client.update_attribute("last_request", Time.now)
    end
  end
  
  def connect_customer(session_id, login, password)
    @client = Client.find_by_session_id(session_id)
    if @client.nil?
      raise XMLRPC::FaultException.new(-3, "Client not found")
    else
      if @client.state =="connected"
        raise XMLRPC::FaultException.new(-10, "Already connected")
      else
        @customer = Customer.find_by_uid(login)
        @ldap_customer = LdapCustomer.find(login)
        operation_type = "operations.utilization"
        operation_controller = "operations.customer"
        operation_action = "operations.connection"
        if @customer.nil?
          raise XMLRPC::FaultException.new(-4, "Login not found")
          Operation.add(operation_type, operation_controller, operation_action, "operations.customers.connection_login_invalid, " + login);
        else
          if !@ldap_customer.valid_password?(password)
            raise XMLRPC::FaultException.new(-5, "Password invalid")
            Operation.add(operation_type, operation_controller, operation_action, "operations.customers.connection_password_invalid, " + login)
          else
            if @customer.time == 0
              raise XMLRPC::FaultException.new(-6, "No time left")
              Operation.add(operation_type, operation_controller, operation_action, "operations.customers.connection_no_time_left, " + login)
            else
              @client.connect!
              @customer.update_attribute("last_login_at", Time.now)
              @client.update_attributes(:customer_id => @customer.id, :last_request => Time.now)
              Operation.add(operation_type, operation_controller, operation_action, login)
              return true
            end
          end
        end
      end
    end
  end

  def connect_timecode(session_id, code)
    @client = Client.find_by_session_id(session_id)
    if @client.nil?
      raise XMLRPC::FaultException.new(-3, "Client not found")
    else
      if @client.state == "connected"
        raise XMLRPC::FaultException.new(-10, "Already connected")
      else
        @timecode = Timecode.find_by_code(code)
        operation_type = "operations.utilization"
        operation_controller = "operations.timecode"
        operation_action = "operations.connection"
        if @timecode.nil?
          raise XMLRPC::FaultException.new(-7, "Timecode not found")
          Operation.add(operation_type, operation_controller, operation_action, "operations.timecodes.connection_not_found, " +  code)
        else
          if !@timecode.is_valid?
            raise XMLRPC::FaultException.new(-8, "Timecode is invalid")
            Operation.add(operation_type, operation_controller, operation_action, "operations.timecodes.connection_invalid, " + @timecode.code)
            @timecode.destroy
          else
            if !@timecode.customer.nil?
              raise XMLRPC::FaultException.new(-9, "Timecode is associated with a customer. Please login using your customer's account")
              Operation.add(operation_type, operation_controller, operation_action, "operations.timecodes.connection_invalid, " + @timecode.code)
            else
              @client.connect!
              @client.update_attributes(:timecode_id => @timecode.id, :last_request => Time.now)
              Operation.add(operation_type, operation_controller, operation_action, @timecode.code)
              return true
            end
          end
        end
      end
    end
  end

  def disconnect(session_id)
    @client = Client.find_by_session_id(session_id)
    if @client.nil?
      raise XMLRPC::FaultException.new(-3, "Client not found")
    else
      operation_type = "operations.utilization"
      operation_action = "operations.disconnect"
      if @client.type() == "timecode"
        Operation.add(operation_type, "operations.timecode", operation_action, @client.timecode.code)
      elsif @client.type() == "customer"
        Operation.add(operation_type, "operations.customer", operation_action, @client.customer.uid)
      end
      if @client.state == "connected"
        @client.disconnect!
        @client.update_attributes(:timecode_id => nil, :customer_id => nil)
      end
      return true
    end
  end

  def decrement_time(session_id)
    @client = Client.find_by_session_id(session_id)
    if @client.nil?
      raise XMLRPC::FaultException.new(-3, "Client not found")
    else
      if @client.state != "connected"
        raise XMLRPC::FaultException.new(-13, "Client must be connected")
      else
        if @client.type() == "timecode"
          if @client.timecode.unlimited == false
            time = @client.timecode.time - 1
            @client.timecode.update_attributes(:time => time)
            return time
          else
            raise XMLRPC::FaultException.new(-14, "Timecode is unlimited")
          end
        elsif @client.type() == "customer"
          time = @client.customer.time
          if time != -1
            @client.customer.decrement_time()
            return @client.customer.time
          else
            raise XMLRPC::FaultException.new(-15, "Customer has unlimited time")
          end
        end
      end
    end
  end
  
  private
  def determine_ip(request)
    request.env["HTTP_X_FORWARDED_FOR"] || request.remote_addr
  end
end
