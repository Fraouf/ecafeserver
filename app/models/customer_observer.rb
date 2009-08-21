class CustomerObserver < ActiveRecord::Observer
  #TODO: implement a credit operation ??
  def after_create(customer)
    Operation.add(I18n.t('operations.customers.create', :login => customer.login))
  end

   def after_destroy(customer)
    Operation.add(I18n.t('operations.customers.destroy', :login => customer.login))
  end
end
