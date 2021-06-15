class Users::ConfirmationsController < Devise::ConfirmationsController
  private
  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource) # In case you want to sign in the user
    root_path
    # your_new_after_confirmation_path
  end
end
