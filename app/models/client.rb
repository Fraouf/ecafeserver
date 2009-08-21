require 'aasm'
class Client < ActiveRecord::Base
  set_primary_key "session_id"
  include UuidHelper
  include AASM
  belongs_to :customer
  belongs_to :timecode

  validates_presence_of :ip_address
  validates_presence_of :hostname
  validates_presence_of :port

  aasm_column :state
  aasm_initial_state :available

  aasm_state :available
  aasm_state :connected

  aasm_event :connect do
    transitions :to => :connected, :from => [:available]
  end

  aasm_event :disconnect do
    transitions :to => :available, :from => [:connected]
  end

  aasm_event :timeout do
    transitions :to => :available, :from => [:connected]
  end
  
  def type
    if self.customer.nil?
      if self.timecode.nil?
        return ""
      else
        return "timecode"
      end
    else
      return "customer"
    end
  end

end
