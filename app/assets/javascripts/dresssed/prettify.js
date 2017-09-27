//= require prettify/prettify

function initPrettify() {
  PR.prettyPrint()
}

Dresssed.hookOnPageLoad( function() {
  Dresssed.jsLibIsActive('prettify') && initPrettify.call(this)
})
