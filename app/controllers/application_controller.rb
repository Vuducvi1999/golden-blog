class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  add_flash_types :info

  def after_sign_in_path_for(resource)
    :root
  end
  
  protected
    def configure_permitted_parameters
      added_attrs = [:avatar, :username, :email, :password, :password_confirmation, :remember_me]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :sign_in, keys: [:login, :password]
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end

    def is_admin
      current_user.role == User::ROLES[:admin]
    end
  
    def is_author
      current_user.id == @post.user.id
    end

    def is_new_post
      @post.status == Post::STATUS[:new]
    end

    def is_rejected_post
      @post.status == Post::STATUS[:rejected]
    end
end
