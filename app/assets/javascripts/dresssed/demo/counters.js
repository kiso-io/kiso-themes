
function initDemoCounters() {
  function count(options) {
    var $this = $(this);
    options = $.extend({}, options || {}, $this.data('countToOptions') || {});
    $this.countTo(options);
  }

  $('.counter').data('countToOptions', {
    onComplete: function (value) {
      var timeout = setTimeout(function() {
        count.call(this, {
          from: value,
          to: value + (Math.floor(value * (1/90)))
        });
        clearTimeout(timeout)
      }.bind(this), 2000 + Math.floor(Math.random() * 10000))
    },
    formatter: function (value, options) {
      return value.toFixed(0).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,")
    }
  });

  $('.cash-counter').data('countToOptions', {
    onComplete: function (value) {
      var timeout = setTimeout(function() {
        count.call(this, {
          from: value,
          to: value + (Math.floor(value * (1/90)))
        });
        clearTimeout(timeout)
      }.bind(this), 3550 + Math.floor(Math.random() * 10000))
    },
    formatter: function (value, options) {
      return '$' + value.toFixed(0).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,")
    }
  });

  $('.counter').each(count)
  $('.cash-counter').each(count)
}

Dresssed.hookOnPageLoad( function() {
  Dresssed.jsLibIsActive('demo-counters') && initDemoCounters.call(this)
})
