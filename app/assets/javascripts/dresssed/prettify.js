//= require prettify/prettify

(function() {
  function initPrettify() {
    PR.prettyPrint()
  }

  Dresssed.hookOnPageLoad( function() {
    Dresssed.jsLibIsActive('prettify') && initPrettify.call(this)
  })
})()

