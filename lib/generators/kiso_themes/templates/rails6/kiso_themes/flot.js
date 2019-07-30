
(function() {
  function initFlot() {
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('flot') && initFlot.call(this)
  })
})()


