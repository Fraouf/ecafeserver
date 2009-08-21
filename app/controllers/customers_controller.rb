class CustomersController < ApplicationController
  before_filter :login_required
  
  def new
    @customer = Customer.new
  end

  def index
    @customers = Customer.find(:all)
  end

  def create
		@customer = Customer.new(params[:customer])
		success = @customer && @customer.save
		if success && @customer.errors.empty?
		  redirect_to :controller => "customers", :action => "index"
		  flash[:notice] = t 'customers.added_successfully'
		else
		  render :action => 'new'
		end
	end

  def destroy
		@customer = Customer.find_by_id(params[:id])
		if @customer
			@customer.destroy
			flash[:notice] = t 'customers.deleted_successfully'
			redirect_to :controller => "customers", :action => "index"
		end
	end
end
