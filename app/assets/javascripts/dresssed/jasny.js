//= require jasny/jasny_bootstrap

(function() {

  function initJasny() {
  }

  Dresssed.hookOnPageLoad( function() {
    Dresssed.jsLibIsActive('jasny') && initJasny.call(this)
  })

})()

