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
    console.log(data)
    
    if(data.action === 'add'){
      target.prepend(data.html_header);
      $(`#notifications-container`).append(data.html_toast);
      const count = 1
      number_notifications.text(parseInt(number_notifications.text()) + count)
    }else if(data.action === 'remove'){
      $(`#notification_id_${notification.id}`).remove();
      const count = parseInt(data.desc_number)||1
      number_notifications.text(parseInt(number_notifications.text()) - count)
    }
  }
});
