class CustomerObserver < ActiveRecord::Observer
  #TODO: implement a credit operation ??
  def after_create(customer)
    Operation.add("operations.administration", "operations.customer", "operations.create", customer.uid)
  end

   def after_destroy(customer)
    Operation.add("operations.administration", "operations.customer", "operations.destroy", customer.uid)
  end
end
