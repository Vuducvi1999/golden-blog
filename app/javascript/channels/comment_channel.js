import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const number_comments = data.number_comments;
    console.log(data)
    if(data.action === "create"){
      $("#comments-list").prepend(data.html)
      $("#count-number-comments").html(`${number_comments} comments`)
      $("#comments_count_post").html(number_comments)
    }
    if(data.action === 'destroy'){
      $(`#comment_id_${data.comment.id}`).remove()
      $("#count-number-comments").html(`${number_comments} comments`)
      $("#comments_count_post").html(number_comments)
      if(number_comments === 0)
        $("#comments-list").html(
          `<i class='my-3' id='message-no-comment' style="font-size:1.1rem"> 
            Haven't had comments! Be the first user comment.
          </i>`
        )
    }
    if(data.action === 'reply'){
      $(`#reply_container_id_${data.comment.id}`).prepend(
        `<div class="offset-1">
          ${data.html}
        </div>`
      )

      $("#count-number-comments").html(`${number_comments} comments`)
      $("#comments_count_post").html(`${number_comments}`)

    }
  }
});
