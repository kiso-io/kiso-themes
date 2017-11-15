
(function() {
  function initGMaps() {
  }

  RRT.hookOnPageLoad( function() {
    RRT.jsLibIsActive('gmaps') && initGMaps.call(this)
  })
})()
