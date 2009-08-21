class TimecodeObserver < ActiveRecord::Observer
  def after_create(timecode)
    Operation.add(I18n.t('operations.timecodes.create', :code => timecode.code))
    credit = Credit.new(:amount => timecode.price, :timecode_id => timecode.id)
    credit.save
  end

  def after_destroy(timecode)
    Operation.add(I18n.t('operations.timecodes.destroy', :code => timecode.code))
  end
end
