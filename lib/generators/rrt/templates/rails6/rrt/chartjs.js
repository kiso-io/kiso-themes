
(function() {

  function initChartJS() {
  }

  RRT.hookOnPageLoad( function() {
    RRT.jsLibIsActive('chartjs') && initChartJS.call(this)
  })

})()
