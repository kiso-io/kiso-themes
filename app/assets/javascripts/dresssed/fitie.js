//= require fitie/fitie

(function() {

  function initFitIe() {
  }

  Dresssed.hookOnPageLoad( function() {
    Dresssed.jsLibIsActive('fitie') && initFitIe.call(this)
  })

})()


