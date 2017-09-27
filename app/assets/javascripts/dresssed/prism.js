//= require prism/prism

function initPrism() {
}

Dresssed.hookOnPageLoad( function() {
  Dresssed.jsLibIsActive('prism') && initPrism.call(this)
})
