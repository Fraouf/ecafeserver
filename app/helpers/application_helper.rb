# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def flash_helper
    		f_names = [:notice, :warning, :message, :error]
    		fl = ''
    		for name in f_names
    			if flash[name]
				logger.debug "Flash name: #{name.inspect}"
				if name == :error
					fl = fl + "<div class=\"error\">#{flash[name]}</div>"
				else
    					fl = fl + "<div class=\"notice\">#{flash[name]}</div>"
				end
    			end
    			flash[name] = nil;
    		end
    		return fl
	end
end
