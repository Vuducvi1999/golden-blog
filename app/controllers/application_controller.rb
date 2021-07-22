class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError do |e| 
    flash[:alert] = I18n.t "#{e.message}", scope: "pundit.errors", default: :default
    redirect_to(request.referrer || root_path)
  end

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  add_flash_types :info

  def after_sign_in_path_for(resource) 
    root_path 
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
end
