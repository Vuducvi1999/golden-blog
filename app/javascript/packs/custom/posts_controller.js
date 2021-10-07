
document.addEventListener('turbolinks:load',()=>{
  const clickers = $('#change-status-actions a')
  
  // // clickers.toArray().forEach((clicker)=>{
  // //   clicker.on('click', function() {
  // //     console.log($(this).nextAll('.spinner-border'))
  // //     $(this).nextAll('.spinner-border').addClass('d-block').removeClass('d-none')
  // //   })
  // // })
  // const clickers = $('#test-click-me')
  
  clickers.toArray().forEach((clicker)=>{
    $(clicker).click(()=>{
      $(clicker).nextAll('.spinner-border').addClass('d-block').removeClass('d-none')
      clickers.toArray().forEach(item=> $(item).hide())
    })
  })
})
