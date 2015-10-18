//= require_tree ./dresssed
//= require_tree ./generators
//= require_tree ./demo

$(document).ready(function(){
  if( Modernizr.touch ) {
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

  if(!Modernizr.touch && width > 800) {
    $('#menu-content').slimScroll({
         height: 'auto'
     });
  } else {
    $('#menu-content').height(0);
    $('#menu-content').slimScroll({
         destroy: 'true'
     });
  }

  // AHOY THERE!
  //
  // This code exists purely for the situation of when the demo
  // app hosts the Ives theme. Slimscroll will prevent the sidenav
  // bar from collapsing correctly ONLY in the circumstance that
  // someone is wanking the browser window back and forth.
  //
  // It is safe to delete this code yourself.
  $(window).on('resize', function(){
    if( Modernizr.touch ) return;

    width = document.body.clientWidth;

    if(width<800) {
      $('#menu-content').height(0);
      $('#menu-content').slimScroll({
           destroy: 'true'
       });
    } else if( width > 800) {
      $('#menu-content').slimScroll({
           height: '100%'
       });
    }
    sizeiframe(width);
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
