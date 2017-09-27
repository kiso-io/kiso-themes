
function initRickshaw() {
}

Dresssed.hookOnPageLoad( function() {
  Dresssed.jsLibIsActive('rickshaw') && initRickshaw.call(this)
})

