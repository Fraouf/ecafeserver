require 'rubygems'
require 'uuidtools'
module UuidHelper
  def before_create()
    self.session_id = UUIDTools::UUID.timestamp_create().to_s
  end
end

