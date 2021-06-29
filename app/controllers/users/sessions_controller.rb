class Users::SessionsController < Devise::SessionsController

  before_action :destroy_cart, only: :destroy

  def destroy_cart
    current_user.update access_token:''
  end
end