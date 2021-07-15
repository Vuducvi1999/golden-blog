class Dashboard::NotificationsController < ApplicationController
  before_action :check_user
  before_action :check_notification
  def readed
    notification = Notification.find(notification_id)
    notification.update(readed: true) 
    redirect_to notification.link 
  end

  private
  def notification_id 
    params[:notification_id].to_i
  end

  def user_id
    params[:user_id].to_i
  end

  def check_user
    if current_user.id != user_id 
      return redirect_back fallback_location: root_path, alert: "Only user can read notification" 
    end
  end

  def check_notification
    notification = Notification.find_by id: notification_id
    unless notification
      return redirect_back fallback_location: root_path, info: "Notification not found or was being removed" 
    end
  end

end