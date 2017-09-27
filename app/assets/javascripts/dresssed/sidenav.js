
function initSidenav() {
  var width = document.body.clientWidth;

  if (!Modernizr.touch && width > 1025) {
    $('#menu-content').slimScroll({
      height: $('#menu-content').outerHeight(),
      color: '#cdcdcd',
      size: '4px',
      opacity: 0.9,
      wheelStep: 15,
      distance: '0',
      railVisible: false,
      railOpacity: 1
    });

    $('#menu-content').mouseover();
  } else {
    $('#menu-content').height(0);
    $('#menu-content').slimScroll({
      destroy: 'true'
    });

    $('#menu-content').mouseover();
  }

  $(window).on('resize', function() {
    if (Modernizr.touch) return;

    width = document.body.clientWidth;

    if (width < 1025) {
      $('#menu-content').height(0);
      $('#menu-content').slimScroll({
        destroy: 'true'
      });
    } else {
      $('#menu-content').slimScroll({
        destroy: 'true'
      });
      $('#menu-content').slimScroll({
        height: '100%'
      });

      $('#menu-content').mouseover();
    }
  });
}

Dresssed.hookOnPageLoad( function() {
  Dresssed.jsLibIsActive('sidenav') && initFastClick.call(this)
})
