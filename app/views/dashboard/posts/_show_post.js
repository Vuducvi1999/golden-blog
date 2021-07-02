
$( document ).on('turbolinks:load', function() {
  let headerHeight = $('#mainNav').innerHeight();

  $("#vote-component").css({
    top: `${headerHeight}px`
  })
})


