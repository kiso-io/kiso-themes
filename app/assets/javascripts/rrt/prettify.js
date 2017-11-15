//= require prettify/prettify

(function() {
  function initPrettify() {
    PR.prettyPrint()
  }

  RRT.hookOnPageLoad( function() {
    RRT.jsLibIsActive('prettify') && initPrettify.call(this)
  })
})()

