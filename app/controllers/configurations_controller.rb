class ConfigurationsController < ApplicationController
	before_filter :admin_required
	
	def new
		@configuration = Configuration.instance
	end
	
	def create
		@config = Configuration.instance
		response = @config.save(params)
		logger.debug "Config: #{params.inspect}"
		if response == true
			I18n.locale = @config.locale
      flash[:notice] = t 'configuration.changed_successfully'
		else
			case response
				when 'invalid_locale'
					flash[:error] = t 'configuration.invalid_locale'
			end
		end
    redirect_to :controller => "configurations", :action => "new"
	end
end
