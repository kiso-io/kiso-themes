//= require_tree ./dresssed
//= require_tree ./generators
//= require_tree ./demo

$(document).ready(function() {
  if (Modernizr.touch) {
    FastClick.attach(document.body);
  }

  $('[data-toggle="popover"]').popover({
    container: 'body'
  });

  $('[data-toggle="tooltip"]').tooltip({
    container: 'body'
  });

  // Required for the SideNav dropdown nav-side-menu
  $('.nav-side-menu').metisMenu();

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

  // AHOY THERE!
  //
  // This code exists purely for the situation of when the demo
  // app hosts the Ives theme. Slimscroll will prevent the sidenav
  // bar from collapsing correctly ONLY in the circumstance that
  // someone is wanking the browser window back and forth.
  //
  // It is safe to delete this code yourself.
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

    try {
      sizeiframe(width);
    } catch (e) {}
  });

  flotMetric($('#metric-monthly-earnings'), [
    [0, 4],
    [1, 8],
    [2, 14],
    [3, 16],
    [4, 12],
    [5, 26],
    [6, 29],
    [7, 32]
  ]);

  flotMetric($('#metric-cancellations'), [
    [0, 10],
    [1, 10],
    [2, 11],
    [3, 20],
    [4, 12],
    [5, 11],
    [6, 10],
    [7, 10]
  ]);

  flotRealtime();
  rickshawBars();
});
