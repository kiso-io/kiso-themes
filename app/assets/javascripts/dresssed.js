//= require_tree ./dresssed
//= require_tree ./generators
//= require_tree ./demo

$(document).ready(function(){
  $('[data-toggle="popover"]').popover({
    container: 'body'
  });

  $('[data-toggle="tooltip"]').tooltip({
    container: 'body'
  });

  // Required for the SideNav dropdown nav-side-menu
  $('.nav-side-menu').metisMenu();

  if(!Modernizr.touch) {
    $('#menu-content').slimScroll({
         height: 'auto'
     });
  } else {
    $('#menu-content').slimScroll({
         destroy: 'true'
     });
  }

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
