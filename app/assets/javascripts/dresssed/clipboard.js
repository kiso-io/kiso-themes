//= require clipboardjs/clipboard

(function() {

  function initClipboard() {
  }

  Dresssed.hookOnPageLoad( function() {
    Dresssed.jsLibIsActive('clipboard') && initClipboard.call(this)
  })

})()
