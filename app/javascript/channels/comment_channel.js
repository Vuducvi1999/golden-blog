import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if(data.action === "create"){
      $("#comments-list").prepend(data.html)
      $("#count-number-comments").html(`${data.number_comments} comments`)
      $("#comments_count_post").html(data.number_comments)
      $("#text-area-comment").val("")
      $("#message-no-comment").html('')
    }
  }
});
