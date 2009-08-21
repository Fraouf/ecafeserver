class ModelObserver < ActiveRecord::Observer
  def after_create(model)
    Operation.add(I18n.t('operations.models.create', :title => model.title))
  end

  def after_destroy(model)
    Operation.add(I18n.t('operations.models.destroy', :title => model.title))
  end

  def after_update(model)
    Operation.add(I18n.t('operations.models.update', :title => model.title))
  end
end
