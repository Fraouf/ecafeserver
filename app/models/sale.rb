class Sale < ActiveRecord::Base
  belongs_to :timecode

  def self.per_page
    30
    end
end
