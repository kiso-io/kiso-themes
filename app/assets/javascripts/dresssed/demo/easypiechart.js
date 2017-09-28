
(function() {
  function initRickshawDemo() {
  }

  Dresssed.hookOnPageLoad( function() {
    Dresssed.jsLibIsActive('demo-rickshaw') && initRickshawDemo.call(this)
  })

})()

