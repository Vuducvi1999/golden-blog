class ManagePolicy  < Struct.new(:user, :manage)
  def check_admin?
    return raise Pundit::NotAuthorizedError.new('user.admin_access') unless user&.admin?
    return true
  end

  def check_user?
    return raise Pundit::NotAuthorizedError.new('user.user_access') unless user
    return true
  end
end