//= require fastclick/fastclick

function initFastclick() {
  if (Modernizr.touch) {
    FastClick.attach(document.body);
  }
}

Dresssed.hookOnPageLoad( function() {
  Dresssed.jsLibIsActive('fastclick') && initFastClick.call(this)
})
