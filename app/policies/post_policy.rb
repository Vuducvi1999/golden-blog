class PostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    # nếu không phải admin hoặc không phải author 
    unless user&.admin? || user&.is_author_of?(record)
      if record.new_created?
        raise Pundit::NotAuthorizedError.new 'user.waiting_to_approve'
      elsif record.rejected?
        raise Pundit::NotAuthorizedError.new 'user.was_rejected_by_admin'
      end
    end 
    true 
  end

  def approve_post?
    unless user&.admin?
      raise Pundit::NotAuthorizedError.new 'user.deny_approve_action'
    end
  end

  def reject_post?
    unless user&.admin?
      raise Pundit::NotAuthorizedError.new 'user.deny_reject_action'
    end
  end
end
