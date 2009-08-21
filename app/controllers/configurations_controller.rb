class ConfigurationsController < ApplicationController
	before_filter :admin_required
	
	def new
		@configuration = Configuration.instance
	end
	
	def create
		@config = Configuration.instance
		response = @config.save(params)
		logger.debug "Config: #{params.inspect}"
		msg = ""
		success = true
		if response == true
			I18n.locale = @config.locale
			msg = t 'configuration.changed_successfully'
		else
			case response
				when 'invalid_locale'
					msg = t 'configuration.invalid_locale'
					success = false
			end
		end
		respond_to do |format|
			format.json {
				render :json => {:success => success, :msg => msg}
			}
		end
	end
end
