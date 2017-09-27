
function initChartJS() {
}

Dresssed.hookOnPageLoad( function() {
  Dresssed.jsLibIsActive('chartjs') && initChartJS.call(this)
})
