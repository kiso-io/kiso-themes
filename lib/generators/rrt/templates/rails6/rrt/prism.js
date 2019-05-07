//= require vendor/prism/prism

(function() {
  function initPrism() {
  }

  RRT.hookOnPageLoad( function() {
    RRT.jsLibIsActive('prism') && initPrism.call(this)
  })
})()
