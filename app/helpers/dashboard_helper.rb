module DashboardHelper
  def is_admin
    current_user.role == User::ROLES[:admin]
  end

  
end
