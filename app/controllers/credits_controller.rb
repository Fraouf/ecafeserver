class CreditsController < ApplicationController
  before_filter :admin_required

  def index
    @credits = Credit.find(:all)
  end

end
