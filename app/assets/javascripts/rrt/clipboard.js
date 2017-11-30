//= require vendor/clipboardjs/clipboard

(function() {

  function initClipboard() {
  }

  RRT.hookOnPageLoad( function() {
    RRT.jsLibIsActive('clipboard') && initClipboard.call(this)
  })

})()
