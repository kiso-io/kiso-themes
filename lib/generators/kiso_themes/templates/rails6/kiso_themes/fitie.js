//= require vendor/fitie/fitie

(function() {

  function initFitIe() {
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('fitie') && initFitIe.call(this)
  })

})()


