
function initMorris() {
}

Dresssed.hookOnPageLoad( function() {
  Dresssed.jsLibIsActive('morris') && initMorris.call(this)
})

