class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications:#{current_user.id}" 
    stream_from "realtime_like_comment"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
