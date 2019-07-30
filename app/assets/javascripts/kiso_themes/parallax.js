//= require vendor/parallax/parallax

(function() {

  function initParallax() {
    $('[data-parallax="scroll"]').parallax();
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('parallax') && initParallax.call(this)
  })

})()

