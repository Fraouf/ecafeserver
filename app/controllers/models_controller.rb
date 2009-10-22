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

class ModelsController < ApplicationController

	before_filter :admin_required, :except => [:index]
	
	def index
		@models = Model.find(:all)
	end
	
	def new
	end
	
	def create
		@model = Model.new(params[:model])
		if @model.save
			redirect_to :controller => "models", :action => "index"
			flash[:notice] = t 'models.added_successfully'
		else
			render :action => "new"
		end
	end
	
	def destroy
		@model = Model.find_by_id(params[:id])
		if @model
			@model.destroy
			flash[:notice] = t 'models.destroyed_successfully'
			redirect_to :controller => "models", :action => "index"
		end
	end
	
	def edit
		@model = Model.find_by_id(params[:id])
	end
	
	def update
		@model = Model.find_by_id(params[:id])
		if @model.update_attributes(params[:model])
			redirect_to :controller => "models", :action => "index"
			flash[:notice] = t 'models.edit_successful'
		else
			render :action => 'edit'
		end
	end
end
