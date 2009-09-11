class TimecodeObserver < ActiveRecord::Observer
  def after_create(timecode)
    Operation.add("operations.sale", "operations.timecode", "operations.create", timecode.code)
    sale = Sale.new(:amount => timecode.price, :timecode_id => timecode.id)
    sale.save
  end

  def after_destroy(timecode)
    Operation.add("operations.sale", "operations.timecode", "operations.destroy", timecode.code)
  end
end
