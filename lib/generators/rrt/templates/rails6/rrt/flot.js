
(function() {
  function initFlot() {
  }

  RRT.hookOnPageLoad( function() {
    RRT.jsLibIsActive('flot') && initFlot.call(this)
  })
})()


