//= require vendor/prism/prism

(function() {
  function initPrism() {
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('prism') && initPrism.call(this)
  })
})()
