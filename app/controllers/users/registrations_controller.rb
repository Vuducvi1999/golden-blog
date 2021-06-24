class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_update_field, only: %i[update]

  def check_update_field
    find_record = User.where.not(id:current_user.id).where(username: params[:user][:username])

    if find_record.present?
      flash[:alert] = 'username already exist'
      
    elsif params[:user][:current_password].blank?
      flash[:alert] = "Current password can\\'t be blank"
      
    end
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    flash[:info] = "Username has already exist so we change it into #{resource.email.split("@")[0]}. But you can edit again in profile!"
    root_path
  end
  
end