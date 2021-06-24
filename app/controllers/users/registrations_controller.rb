class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_username_exist, only: %i[update]

  def check_username_exist 
    find_record = User.where(username: params[:user][:username])
    if find_record.present?
      flash[:alert] = 'username already exist'
      
      # redirect_to edit_user_registration_path
    elsif params[:user][:current_password].empty?
      flash.alert = "Current password can\\'t be blank"
      
      # redirect_to edit_user_registration_path
    end

  end
end