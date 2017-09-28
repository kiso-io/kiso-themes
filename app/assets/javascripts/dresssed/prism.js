//= require prism/prism

(function() {
  function initPrism() {
  }

  Dresssed.hookOnPageLoad( function() {
    Dresssed.jsLibIsActive('prism') && initPrism.call(this)
  })
})()
