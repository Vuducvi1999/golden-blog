class ApplicationController < ActionController::Base
  include Pundit
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from Pundit::NotAuthorizedError do |e| 
    puts "pundit.errors.#{e.message}"
    flash[:alert] = I18n.t "pundit.errors.#{e.message}", scope: "pundit.errors", default: :default
    redirect_to(privacy_path)
    
  end

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  add_flash_types :info

  def after_sign_in_path_for(resource) 
    :root 
  end

  def self.render_with_signed_in_user(user, *args)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap{|i| i.set_user(user, scope: :user, run_callbacks: false) }
    renderer = self.renderer.new('warden' => proxy)
    renderer.render(*args)
  end
  
  protected
    def configure_permitted_parameters
      added_attrs = [:avatar, :username, :email, :password, :password_confirmation, :remember_me]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :sign_in, keys: [:login, :password]
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end
    
  private 
    def user_not_authorized exception

      flash[:error] = I18n.t "pundit.errors.#{exception.reason}", scope: "pundit.errors", default: :default
      redirect_back fallback_location:root_path
    end
end
