class NotificationPolicy < ApplicationPolicy
  def readed?
    if user&.id == record.recipient.id 
      return true 
    end 
    false 
  end
end