
document.addEventListener('turbolinks:load',()=>{
  const clickers = $('#change-status-actions a')
  
  clickers.toArray().forEach((clicker) => {
    $(clicker).click(()=>{
      $(clicker).nextAll('.spinner-border').addClass('d-block').removeClass('d-none')
      clickers.toArray().forEach(item=> $(item).hide())
    })
  })
  
  $('#share-facebook-btn').click(() => {
    FB.ui({
      display: 'popup',
      method: 'share',
      href: "#{url_for(only_path:false)}",
    }, function(response){});
  })
})
