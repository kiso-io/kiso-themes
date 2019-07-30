//= require vendor/countdown/countdown

(function() {

  function initCountdown() {
    var els = $('.countdown')

    els.each(function() {
      var el = $(this)
      var countDownTo = el.attr('data-countdownto')

      el.countdown(countDownTo, function(event) {
        var $this = $(this).html(event.strftime(''
                                                + '<div class="countDownWrap"><span class="digits">%-D</span> <div class="digits-label">day%!d</div></div> '
                                                + '<div class="countDownWrap"><span class="digits">%H</span> <div class="digits-label">hours</div></div> '
                                                + '<div class="countDownWrap"><span class="digits">%M</span> <div class="digits-label">minutes</div></div> '
                                                + '<div class="countDownWrap"><span class="digits">%S</span> <div class="digits-label">seconds</div></div> '))

      })
    })
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('countdown') && initCountdown.call(this)
  })

})()

