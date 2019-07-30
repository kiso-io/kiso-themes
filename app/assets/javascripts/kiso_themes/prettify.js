//= require vendor/prettify/prettify

(function() {
  function initPrettify() {
    PR.prettyPrint()
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('prettify') && initPrettify.call(this)
  })
})()

