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
