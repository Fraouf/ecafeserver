class Operation < ActiveRecord::Base
  def self.add(type, controller, action, arguments)
    user = ''
    unless Employee.current.nil?
      user = Employee.current.login
    end
    operation = Operation.new(:user => user, :operation_type => type, :controller => controller, :action => action, :arguments => arguments)
    operation.save
  end

  def self.per_page
    30
  end
end
