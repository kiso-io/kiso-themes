//= require parallax/parallax

(function() {

  function initParallax() {
  }

  Dresssed.hookOnPageLoad( function() {
    Dresssed.jsLibIsActive('parallax') && initParallax.call(this)
  })

})()

