(function() {
  function initGMaps() {
  }

  Dresssed.hookOnPageLoad( function() {
    Dresssed.jsLibIsActive('gmaps') && initGMaps.call(this)
  })
})()
