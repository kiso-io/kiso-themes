//= require clipboardjs/clipboard


function initClipboard() {
}

Dresssed.hookOnPageLoad( function() {
  Dresssed.jsLibIsActive('clipboard') && initClipboard.call(this)
})
