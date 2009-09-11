class ModelObserver < ActiveRecord::Observer
  def after_create(model)
    Operation.add("operations.administration", "operations.model", "operations.create", model.title)
  end

  def after_destroy(model)
    Operation.add("operations.administration", "operations.model", "operations.destroy", model.title)
  end

  def after_update(model)
    Operation.add("operations.administration", "operations.model", "operations.update", model.title)
  end
end
