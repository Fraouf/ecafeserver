# Copyright (C) 2009 Guillaume Viguier-Just
#
# Author: Guillaume Viguier-Just <guillaume@viguierjust.com>
#
# This file is part of ecafeserver.
#
# Ecafeserver is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ecafeserver is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ecafeserver.  If not, see <http://www.gnu.org/licenses/>.

class Model < ActiveRecord::Base
	has_one :group
	
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
