class EmployeesController < ApplicationController
	before_filter :admin_required, :except => [:edit_profile, :update_profile]
	
	def index
		@employees = Employee.find(:all)
	end
  
	# render new.rhtml
	def new
		@employee = Employee.new
	end

	def create
		@employee = Employee.new(params[:employee])
		success = @employee && @employee.save
		if success && @employee.errors.empty?
		  redirect_to :controller => "employees", :action => "index"
		  flash[:notice] = t 'employees.added_successfully'
		else
		  render :action => 'new'
		end
	end
	
	def destroy
		@employee = Employee.find_by_id(params[:id])
		if @employee
			@employee.destroy
			flash[:notice] = t 'employees.deleted_successfully'
			redirect_to :controller => "employees", :action => "index"
		end
	end
	
	def edit
		@employee = Employee.find_by_id(params[:id])
	end
	
	def update
		@employee = Employee.find_by_id(params[:id])
		if @employee.update_attributes(params[:employee])
			redirect_to :controller => "employees", :action => "index"
			flash[:notice] = t 'employees.edit_successful'
		else
			render :action => 'edit'
		end
	end
	
	def edit_profile
		@employee = current_employee
	end
	
	def update_profile
		if current_employee.update_attributes(params[:employee])
			redirect_to :controller => "employees", :action => "edit_profile"
			flash[:notice] = t 'employees.edit_profile_successful'
		else
			render :action => 'edit_profile'
		end
	end
	
end
