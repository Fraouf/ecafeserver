class Operation < ActiveRecord::Base
  def self.add(title)
    if Employee.current.nil?
      operation = Operation.new(:user => '', :title => title)
    else
      operation = Operation.new(:user => Employee.current.login, :title => title)
    end
    operation.save
  end
end
