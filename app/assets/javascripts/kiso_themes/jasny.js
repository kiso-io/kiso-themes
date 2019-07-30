//= require vendor/jasny/jasny_bootstrap

(function() {

  function initJasny() {
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('jasny') && initJasny.call(this)
  })

})()

