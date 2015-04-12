//= require counter_animator

$(document).ready(function(){
  if( Modernizr.touch ) {
    return;
  }

  var pageHitAnimator = new CounterAnimator( '.page-hits', 1123 );

  function update() {
    if(!$('.page-hits').hasClass('animating')) {
      var percentIncrease = 1+0.05;
      var targetValue = parseInt( $('.page-hits').text().replace(/,/g, '') ) * percentIncrease;
      pageHitAnimator.animateTo( targetValue );
    }

    setTimeout(update, 5000 + Math.random() * 10000);
  }

  update()
});