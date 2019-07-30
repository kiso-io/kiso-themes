//= require vendor/fastclick/fastclick

(function() {

  function initFastclick() {
    if (Modernizr.touch) {
      FastClick.attach(document.body);
    }
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('fastclick') && initFastclick.call(this)
  })

})()

