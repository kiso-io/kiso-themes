//= require ./dresssed/kernel
//= require ./dresssed/fastclick
//= require ./dresssed/slimscroll
//= require ./dresssed/metis_menu
//= require ./dresssed/header
//= require ./dresssed/popper
//= require ./dresssed/bootstrap
//= require ./dresssed/sheets
//= require ./dresssed/maps
//= require ./dresssed/flot
//= require ./dresssed/rickshaw
//= require ./dresssed/fastclick
//= require ./dresssed/prettify
//= require ./dresssed/morris
//= require ./dresssed/chartjs
//= require ./dresssed/countTo
//= require ./dresssed/demo/counters
//= require ./prism/prism
//= require ./clipboardjs/clipboard

//= require_tree ./generators
//= require_tree ./demo
//= require ./inspect_mode/inspect_mode


Popper.Defaults.modifiers.computeStyle.gpuAcceleration = false;


$(document).ready(function() {
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
  salesVsRefunds();

});
