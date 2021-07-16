class ManagePolicy  < Struct.new(:user, :manage)
  def check_admin?
    return raise Pundit::NotAuthorizedError.new('user.admin_access') unless user&.admin?
    return true
  end
end