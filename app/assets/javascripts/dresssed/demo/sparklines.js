
(function() {
  function initMorrisDemo() {
  }

  Dresssed.hookOnPageLoad( function() {
    Dresssed.jsLibIsActive('demo-morris') && initMorrisDemo.call(this)
  })
})()

