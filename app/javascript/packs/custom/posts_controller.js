
document.addEventListener('turbolinks:load',()=>{
  const clickers = $('#change-status-actions a')
  
  clickers.toArray().forEach((clicker) => {
    $(clicker).click(()=>{
      $(clicker).nextAll('.spinner-border').addClass('d-block').removeClass('d-none')
      clickers.toArray().forEach(item=> $(item).hide())
    })
  })
  
  $('#share-facebook-btn').click(() => {
    window.open('https://www.facebook.com/sharer/sharer.php?u=' + document.URL,
                'facebook-share-dialog',"width=626, height=436")
  })
})
