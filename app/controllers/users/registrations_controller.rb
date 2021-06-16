class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_update_field, only: %i[update]

  def check_update_field
    find_record = User.where(username: params[:user][:username])

    if find_record.present?
      flash[:alert] = 'username already exist'
      
    elsif params[:user][:current_password].blank?
      flash[:alert] = "Current password can\\'t be blank"
      
    end
  end
  
end