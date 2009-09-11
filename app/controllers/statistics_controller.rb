class StatisticsController < ApplicationController
  before_filter :login_required

  def index
    if(params[:commit].nil?)
      @date = Date.today
    else
      @date = Date.civil(params[:range][:"from(1i)"].to_i,params[:range][:"from(2i)"].to_i,params[:range][:"from(3i)"].to_i)
    end
    @time = @date.midnight
    @day_amount = 0
    Sale.find_each(:conditions => { :created_at => (@time)..(@time + 1.day) }) do |sale|
      @day_amount += sale.amount
    end
    @day_timecodes = Timecode.count(:conditions => { :created_at => (@time)..(@time + 1.day) })
    @day_customers = Customer.count(:conditions => { :created_at => (@time)..(@time + 1.day) })
  end

end
