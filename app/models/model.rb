class Model < ActiveRecord::Base
	validates_presence_of :title, :message => :model_title_presence
	validates_length_of   :title, :within => 3..100, :message => :model_title_length
	validates_uniqueness_of	:title, :message => :model_title_uniqueness
	
	validates_presence_of :price, :message => :model_price_presence
	validates_numericality_of :price, :only_integer => true, :greater_than_or_equal_to => 0, :message => :model_price_numericality
	
	validates_presence_of :expiration, :message => :model_expiration_presence
	validates_numericality_of :expiration, :only_integer => true, :greater_than_or_equal_to => 0, :message => :model_expiration_numericality
	
	validates_presence_of :time, :message => :model_time_presence
	validates_numericality_of :time, :only_integer => true, :greater_than_or_equal_to => 0, :message => :model_time_numericality
	
	HUMAN_ATTRIBUTES = {
		:title	=>	"",
		:price	=>	"",
		:expiration	=>	"",
		:time	=> ""
	}
	
	def self.human_attribute_name(attr)
		HUMAN_ATTRIBUTES[attr.to_sym] || super
	end
end
