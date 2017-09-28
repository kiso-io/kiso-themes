
(function() {
  function initFlot() {
  }

  Dresssed.hookOnPageLoad( function() {
    Dresssed.jsLibIsActive('flot') && initFlot.call(this)
  })
})()


