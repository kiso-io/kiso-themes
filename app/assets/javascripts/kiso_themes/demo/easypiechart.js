
(function() {
  function initEasyPieChartDemo() {

    jQuery('.js-pie-chart:not(.js-pie-chart-enabled)').each(function(){
      var el = jQuery(this);

      // Add .js-pie-chart-enabled class to tag it as activated
      el.addClass('js-pie-chart-enabled');

      // Init
      el.easyPieChart({
        barColor: el.data('bar-color') || '#777777',
        trackColor: el.data('track-color') || '#eeeeee',
        lineWidth: el.data('line-width') || 3,
        size: el.data('size') || '80',
        animate: el.data('animate') || 750,
        scaleColor: el.data('scale-color') || false
      });
    });

    jQuery('.js-pie-randomize').on('click', function(){
            jQuery(this)
                .parents('.block')
                .find('.pie-chart')
                .each(function() {
                    var random = Math.floor((Math.random() * 100) + 1);

                    jQuery(this)
                        .data('easyPieChart')
                        .update(random);
                });
        });
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('demo-easypiechart') && initEasyPieChartDemo.call(this)
  })

})()

