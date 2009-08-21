class OperationsController < ApplicationController
	before_filter :admin_required
	
	def index
		@operations = Operation.find(:all)
	end
end
