class CustomersController < ApplicationController
  before_filter :login_required
  
  def new
    @customer = Customer.new
  end

  def index
    if(params[:q].nil?)
      @customers = Customer.paginate :page => params[:page], :order => "created_at DESC"
    else
      @customers = Customer.paginate :conditions => ["login LIKE ?",  params[:q].concat("%")], :page => params[:page], :order => "created_at DESC"
    end
  end

  def show
    @customer = Customer.find_by_id(params[:id])
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

  def edit
    @customer = Customer.find_by_id(params[:id])
  end

  def update
		@customer = Customer.find_by_id(params[:id])
    if @customer.update_attributes(params[:customer])
      redirect_to :controller => "customers", :action => "index"
      flash[:notice] = t 'customers.edit_successful'
    else
      render :action => 'edit'
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

  def new_credit
    @models = Model.find(:all)
    @customer = Customer.find_by_id(params[:id])
  end
  
  def create_credit
    @model = Model.find_by_id(params[:model][:id])
    if @model
			@timecode = Timecode.new_from_model(@model)
      @customer = Customer.find_by_id(params[:id])
      if @customer
        @timecode.customer = @customer
        if @timecode.save
          flash[:notice] = I18n.t('timecodes.added_successfully', :code => @timecode.code)
          redirect_to :controller => "customers", :action => "show", :id => @customer.id
        else
          flash[:error] = t 'timecodes.add_failed'
          redirect_to :controller => "customers", :action => "new_credit", :id => @customer.id
        end
      end
		end
  end
end
