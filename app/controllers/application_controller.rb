# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	# locale stuff
	before_filter :set_locale
	def available_locales; AVAILABLE_LOCALES; end
	def set_locale
		# if params[:locale] is nil then I18n.default_locale will be used
		I18n.default_locale = locale()
		I18n.locale = I18n.default_locale
	end

  before_filter :set_request_environment
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include AuthenticatedSystem
  
  helper_method :is_admin?
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
  
  def is_admin?
	current_employee.is_admin
  end
  
  def admin_required
	is_admin? || access_denied
  end
  
  def locale
	config = Configuration.instance
	return config.locale
  end

  private
  def set_request_environment
    Employee.current = current_employee unless current_employee == nil
  end
end
