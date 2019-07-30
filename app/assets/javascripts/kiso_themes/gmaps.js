
(function() {
  function initGMaps() {
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('gmaps') && initGMaps.call(this)
  })
})()
