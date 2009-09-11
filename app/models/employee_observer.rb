class EmployeeObserver < ActiveRecord::Observer
  def after_create(employee)
    Operation.add("operations.administration", "operations.employee", "operations.create", employee.login)
  end

  def after_destroy(employee)
    Operation.add("operations.administration", "operations.employee", "operations.destroy", employee.login)
  end

  # TODO: fix a bug that displays that the employee updated his profile at each login
  #def after_update(employee)
  #  if employee.is_a?(Employee) && !Employee.current.nil?
  #    if employee.login == Employee.current.login
  #      Operation.add(I18n.t('operations.employees.update_profile', :login => employee.login))
  #    else
  #      Operation.add(I18n.t('operations.employees.update', :login => employee.login))
  #    end
  #  end
  #end
end
