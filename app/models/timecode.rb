class Timecode < ActiveRecord::Base
  has_one :credit
  belongs_to :customer
  has_one :client, :dependent => :destroy
  
	def generate_code
		self.code = Digest::SHA1.hexdigest("--#{Time.now.to_s}--")[0,8]
		# check that the generated code does not exist already !!!
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
								:unlimited => unlimited)
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
