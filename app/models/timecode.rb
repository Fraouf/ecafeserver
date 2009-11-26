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

require 'digest/sha1'

class Timecode < ActiveRecord::Base
	has_one :sale
	belongs_to :user
	has_one :client, :dependent => :destroy
	
	validates_uniqueness_of :code
	validates_presence_of :code

	def self.per_page
		10
	end

	def generate_code
		# generate a random number between 0 and 9, to make sure the timecode starts with a number
		initial_num = rand(9)
		co = Digest::SHA1.hexdigest("--#{Time.now.to_s}--")[0,7]
		self.code = initial_num.to_s() + co
		# Make sure the generated code does not exist already and generate a new one if needed
		while (!self.valid?)
			self.generate_code
		end
	end
	
	def self.new_from_model (model)
		expiration = Time.now
		expires = true
		if model.expiration == 0 # Timecode never expires
			expires = false
		else
			expiration = Time.now + model.expiration.days
		end
		unlimited = false
		if model.time == 0
			unlimited = true
		end
		timecode = self.new(:price => model.price,
								:expiration => expiration,
								:expires => expires,
								:time => model.time,
								:unlimited => unlimited,
								:renew => model.renew)
		timecode.generate_code
		logger.debug "#{timecode.inspect}"
		return timecode
	end

	def is_valid?
		if self.expiration < Time.now && self.expires == true # Timecode is expired
			return false
		end
		if self.time <= 0 && self.unlimited == false # Timecode does not have any time left
			return false
		end
		return true
	end
end
