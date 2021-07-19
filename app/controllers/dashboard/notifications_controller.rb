class Dashboard::NotificationsController < Dashboard::BaseController
  before_action :set_notification

  def readed
    authorize @notification
    @notification.update(readed: true) 
    redirect_to @notification.link 
  end

  private
  def notification_id 
    params[:notification_id].to_i
  end

  def set_notification
    @notification = Notification.find_by id: notification_id 
    unless @notification 
      return redirect_back fallback_location: root_path, info: "Notification not found or was being removed" 
    end
  end

end