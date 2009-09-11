class SalesController < ApplicationController
  before_filter :login_required

  def index
    if(params[:commit].nil?)
      @sales = Sale.paginate :page => params[:page], :order => "created_at DESC"
    else
      @date_from = Date.civil(params[:range][:"from(1i)"].to_i,params[:range][:"from(2i)"].to_i,params[:range][:"from(3i)"].to_i)
      @date_to = Date.civil(params[:range][:"to(1i)"].to_i,params[:range][:"to(2i)"].to_i,params[:range][:"to(3i)"].to_i)
      conditions = ["created_at >= ? AND created_at <= ?", @date_from, @date_to]
      @sales = Sale.paginate :page => params[:page], :order => "created_at DESC", :conditions => conditions
    end
  end
end
