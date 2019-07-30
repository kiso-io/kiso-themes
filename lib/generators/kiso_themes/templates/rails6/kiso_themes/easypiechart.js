//= require vendor/easypiechart/jquery.easypiechart

(function() {

  function initEasyPieChart() {
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('easypiechart') && initEasyPieChart.call(this)
  })

})()
