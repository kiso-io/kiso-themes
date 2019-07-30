
(function() {

  function initChartJS() {
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('chartjs') && initChartJS.call(this)
  })

})()
