class PagesController < ApplicationController
	before_filter :login_required
	
	def index
    @clients = Client.all
	end
end
