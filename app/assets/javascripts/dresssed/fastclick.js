//= require fastclick/fastclick

(function() {

  function initFastclick() {
    if (Modernizr.touch) {
      FastClick.attach(document.body);
    }
  }

  Dresssed.hookOnPageLoad( function() {
    Dresssed.jsLibIsActive('fastclick') && initFastclick.call(this)
  })

})()

