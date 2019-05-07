//= require vendor/fastclick/fastclick

(function() {

  function initFastclick() {
    if (Modernizr.touch) {
      FastClick.attach(document.body);
    }
  }

  RRT.hookOnPageLoad( function() {
    RRT.jsLibIsActive('fastclick') && initFastclick.call(this)
  })

})()

