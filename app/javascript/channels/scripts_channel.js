/*!
* Start Bootstrap - Clean Blog v6.0.3 (https://startbootstrap.com/theme/clean-blog)
* Copyright 2013-2021 Start Bootstrap
* Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-clean-blog/blob/master/LICENSE)
*/



document.addEventListener('turbolinks:load', () => {
    let scrollPos = 0;
    const mainNav = document.getElementById('mainNav');
    const headerHeight = mainNav.clientHeight;

    let needTags = document.querySelectorAll('figcaption.attachment__caption')
    needTags.forEach(item=>{
        item.classList.add('caption','text-muted')
        item.classList.remove('attachment__caption')
    })

    // let button_comment = document.getElementById('button-comment')
    // button_comment.addEventListener('click',(event)=>{
    //     setTimeout(() => {
    //         document.getElementById('comments-list').contentWindow.location.reload(true);
    //     }, 1000);
        
        
    // })

    window.addEventListener('scroll', function() {
        const currentTop = document.body.getBoundingClientRect().top * -1;
        
        if ( currentTop < scrollPos) {
            // Scrolling Up
            if (currentTop > 0 && mainNav.classList.contains('is-fixed')) {
                mainNav.classList.add('is-visible');
            } else {
                console.log(123);
                mainNav.classList.remove('is-visible', 'is-fixed');
            }
        } else {
            // Scrolling Down
            mainNav.classList.remove(['is-visible']);
            if (currentTop > headerHeight && !mainNav.classList.contains('is-fixed')) {
                mainNav.classList.add('is-fixed');
            }
        }
        scrollPos = currentTop;
    });
})

