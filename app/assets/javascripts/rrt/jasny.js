//= require vendor/jasny/jasny_bootstrap

(function() {

  function initJasny() {
  }

  RRT.hookOnPageLoad( function() {
    RRT.jsLibIsActive('jasny') && initJasny.call(this)
  })

})()

