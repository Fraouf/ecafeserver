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
