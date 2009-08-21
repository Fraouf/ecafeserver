class TimecodesController < ApplicationController
	before_filter :login_required
	
	def index
		@timecodes = Timecode.find(:all)
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
			if current_employee.is_admin # The employee is an admin, he can delete whatever he wants
        destroy_credit(@timecode) if @timecode.created_at == @timecode.updated_at
				@timecode.destroy
				destroy_success (code)
			else #The employee is a basic employee, he can delete timecodes that have never been used only
				if @timecode.created_at == @timecode.updated_at
          # Destroy credit associated with timecode
          destroy_credit(@timecode)
					@timecode.destroy
					destroy_success (code)
				else
					Operation.add(I18n.t('operations.timecodes.destroy_failed', :code => code))
					flash[:error] = t 'timecodes.destroy_failed'
					redirect_to :controller => "timecodes", :action => "index"
				end
			end
		end
	end
	
	protected
	
	def destroy_success (code)
		flash[:notice] = I18n.t('timecodes.destroyed_successfully', :code => code)
		redirect_to :controller => "timecodes", :action => "index"
	end

  def destroy_credit(timecode)
    credit = Credit.find_by_timecode_id(timecode.id)
    credit.destroy unless credit.nil?
  end
		
end
