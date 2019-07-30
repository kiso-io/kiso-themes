//= require vendor/clipboardjs/clipboard

(function() {

  function initClipboard() {
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('clipboard') && initClipboard.call(this)
  })

})()
