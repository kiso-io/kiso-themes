//= require parallax/parallax

(function() {

  function initParallax() {
  }

  RRT.hookOnPageLoad( function() {
    RRT.jsLibIsActive('parallax') && initParallax.call(this)
  })

})()

