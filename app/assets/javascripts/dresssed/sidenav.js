(function (){

  function getSideNavHeight() {
    var hasSideNavHeader = $('.navbar-header').length > 0
    return hasSideNavHeader ? $('.nav-side-menu').outerHeight() - $('.navbar-header').outerHeight() : $('.nav-side-menu').outerHeight()
  }

  function initSidenav() {
    var width = document.body.clientWidth;

    var sideNavContainer = $('.nav-side-container')

    $('.SideNavToggle').on('click', function() {
      $('body').toggleClass(
        'show-sidebar'
      )
    })



    if (!Modernizr.touch && width > 992) {
      sideNavContainer.slimScroll({
        height: getSideNavHeight(),
        color: '#cdcdcd',
        size: '4px',
        opacity: 0.9,
        wheelStep: 15,
        distance: '0',
        railVisible: false,
        railOpacity: 1
      });

      sideNavContainer.mouseover();
    } else {
      sideNavContainer.slimScroll({ destroy: 'true' });

      sideNavContainer.mouseover();
    }

    $(window).on('resize', Dresssed.debounce(function() {
      if (Modernizr.touch) return;

      width = document.body.clientWidth;

      if (width < 992) {
        sideNavContainer.slimScroll({ destroy: 'true' });
        sideNavContainer.height('auto')

        sideNavContainer.mouseover();
      } else {
        sideNavContainer.slimScroll({ destroy: 'true' });
        sideNavContainer.slimScroll({
          height: getSideNavHeight(),
          color: '#cdcdcd',
          size: '4px',
          opacity: 0.9,
          wheelStep: 15,
          distance: '0',
          railVisible: false,
          railOpacity: 1
        });

        sideNavContainer.mouseover();
      }
    }, 250));
  }

  Dresssed.hookOnPageLoad( function() {
    Dresssed.jsLibIsActive('sidenav') && initSidenav.call(this)
  })
})()

