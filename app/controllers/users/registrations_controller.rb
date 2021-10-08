class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_update_field, only: %i[update]
  before_action :check_sign_up_field, only: %i[create]

  def check_update_field
    find_record = User.where.not(id:current_user.id).where(username: params[:user][:username])

    if find_record.present?
      flash[:alert] = 'username already exist'
      redirect_back(fallback_location: root_path)
    elsif params[:user][:current_password].blank?
      flash[:alert] = "Current password can\\'t be blank"
      redirect_back(fallback_location: root_path)
    end
  end

  def check_sign_up_field
    user_with_same_username = User.where(username: sign_up_params[:username])
    user_with_same_email = User.where(email: sign_up_params[:email])
    
    if user_with_same_username.present?
      flash[:alert] = 'username already exist'
      redirect_back(fallback_location: root_path)
    elsif sign_up_params[:password].blank?
      flash[:alert] = "Password can\\'t be blank"
      redirect_back(fallback_location: root_path)
    elsif sign_up_params[:password_confirmation].blank?
      flash[:alert] = "Confirmation password can\\'t be blank"
      redirect_back(fallback_location: root_path)
    elsif sign_up_params[:email].blank?
      flash[:alert] = "email can\\'t be blank"
      redirect_back(fallback_location: root_path)
    elsif user_with_same_email.present?
      flash[:alert] = "email has already been taken"
      redirect_back(fallback_location: root_path)
    end
  end

  protected
    def after_inactive_sign_up_path_for(resource)
      if User.find_by(username: resource.username).confirmed_at
        flash[:info] = "Username has already exist so we change it into #{resource.email.split("@")[0]}. But you can edit again in profile!"
      end
      root_path
    end

    def sign_up_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
  
end