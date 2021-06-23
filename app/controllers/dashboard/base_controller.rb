class Dashboard::BaseController < ApplicationController
  before_action :check_admin_account

  protected 
  # Check is admin access
  def check_admin_account
    if current_user.role != User::ROLES[:admin]
      flash[:alert]= "Only admin can access"
      return redirect_back fallback_location: root_path
    end
  end
end
