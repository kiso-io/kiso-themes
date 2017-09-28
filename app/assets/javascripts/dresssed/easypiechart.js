//= require easypiechart/jquery.easypiechart

(function() {

  function initEasyPieChart() {
  }

  Dresssed.hookOnPageLoad( function() {
    Dresssed.jsLibIsActive('easypiechart') && initEasyPieChart.call(this)
  })

})()
