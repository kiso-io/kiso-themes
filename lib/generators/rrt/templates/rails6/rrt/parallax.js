//= require vendor/parallax/parallax

(function() {

  function initParallax() {
    $('[data-parallax="scroll"]').parallax();
  }

  RRT.hookOnPageLoad( function() {
    RRT.jsLibIsActive('parallax') && initParallax.call(this)
  })

})()

