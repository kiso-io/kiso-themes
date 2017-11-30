//= require vendor/fitie/fitie

(function() {

  function initFitIe() {
  }

  RRT.hookOnPageLoad( function() {
    RRT.jsLibIsActive('fitie') && initFitIe.call(this)
  })

})()


