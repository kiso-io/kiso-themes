//= require vendor/easypiechart/jquery.easypiechart

(function() {

  function initEasyPieChart() {
  }

  RRT.hookOnPageLoad( function() {
    RRT.jsLibIsActive('easypiechart') && initEasyPieChart.call(this)
  })

})()
