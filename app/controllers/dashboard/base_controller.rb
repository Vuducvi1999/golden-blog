class Dashboard::BaseController < ApplicationController
  before_action :check_admin_account

  protected 
  # Check is admin access
  def check_admin_account
    unless current_user.admin?
      flash[:alert]= "Only admin can access"
      return redirect_back fallback_location: root_path
    end
  end
end
