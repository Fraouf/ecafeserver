class TimecodesController < ApplicationController
	before_filter :login_required
	
	def index
    if(params[:q].nil?)
      @timecodes = Timecode.paginate :conditions => ["customer_id IS NULL"], :page => params[:page], :order => "created_at DESC"
    else
      @timecodes = Timecode.paginate :conditions => ["customer_id IS NULL AND code LIKE ?",  params[:q] + "%"], :page => params[:page], :order => "created_at DESC"
    end
	end
	
	def new
		@models = Model.find(:all)
	end
	
	def create
		@model = Model.find_by_id(params[:model][:id])
		if @model
			@timecode = Timecode.new_from_model(@model)
			if @timecode.save
				flash[:notice] = I18n.t('timecodes.added_successfully', :code => @timecode.code)
				redirect_to :controller => "timecodes", :action => "index"
			else
				flash[:error] = t 'timecodes.add_failed'
				redirect_to :controller => "timecodes", :action => "index"
			end
		end
	end
	
	def destroy
		@timecode = Timecode.find_by_id(params[:id])
		if @timecode
			code = @timecode.code
      customer_id = @timecode.customer_id
			if current_employee.is_admin # The employee is an admin, he can delete whatever he wants
        destroy_sale(@timecode) if @timecode.created_at == @timecode.updated_at
				@timecode.destroy
				destroy_success(code, customer_id)
			else #The employee is a basic employee, he can delete timecodes that have never been used only
				if @timecode.created_at == @timecode.updated_at
          # Destroy sale associated with timecode
          destroy_sale(@timecode)
					@timecode.destroy
					destroy_success(code, customer_id)
				else
					Operation.add("operations.administration", "operations.timecode", "operations.destroy", "operations.timecodes.destroy_failed, " + code)
					flash[:error] = t 'timecodes.destroy_failed'
          if (customer_id.nil?)
            redirect_to :controller => "timecodes", :action => "index"
          else
            redirect_to :controller => "customers", :action => "show", :id => customer_id
          end
				end
			end
		end
	end
	
	protected
	
	def destroy_success (code, customer_id)
		flash[:notice] = I18n.t('timecodes.destroyed_successfully', :code => code)
    if customer_id.nil?
      redirect_to :controller => "timecodes", :action => "index"
    else
      redirect_to :controller => "customers", :action => "show", :id => customer_id
    end
	end

  def destroy_sale(timecode)
    sale = Sale.find_by_timecode_id(timecode.id)
    sale.destroy unless sale.nil?
  end
		
end
