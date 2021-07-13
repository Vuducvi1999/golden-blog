import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    const target = $(`[aria-labelledby="header-notifications"]`)
    const number_notifications = $(`.position-absolute.translate-middle.rounded-pill`)
    const notification = data.notification
    
    if(data.action === 'add'){
      target.prepend(data.html_header);
      $(`#notifications-container`).append(data.html_toast);
      number_notifications.text(parseInt(number_notifications.text()) + 1)
    }else if(data.action === 'remove'){
      $(`#notification_id_${notification.id}`).remove();
      number_notifications.text(parseInt(number_notifications.text()) - 1)
    }
  }
});
