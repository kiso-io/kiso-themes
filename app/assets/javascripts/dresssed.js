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

  // Required for the SideNav dropdown menu
  $('.nav-side-menu').metisMenu();

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
      [0, 0],
      [1, 0],
      [2, 1],
      [3, 0],
      [4, 2],
      [5, 1],
      [6, 0],
      [7, 0]
  ]);

  flotRealtime();
  rickshawBars();
});
