
(function() {

  function lineSparks(el, opts) {
    var lineSpark = jQuery(el);

    var defaultOpts = {
      type: 'line',
      width: '100px',
      height: '60px',
      tooltipOffsetX: -25,
      tooltipOffsetY: 20,
      lineColor: '#ffca28',
      fillColor: '#ffca28',
      spotColor: '#555',
      minSpotColor: '#555',
      maxSpotColor: '#555',
      highlightSpotColor: '#555',
      highlightLineColor: '#555',
      spotRadius: 2,
      tooltipPrefix: '',
      tooltipFormat: '{{prefix}}{{y}}{{suffix}}'
    };

    for (var attrname in opts) { defaultOpts[attrname] = opts[attrname]; }

    if ( lineSpark.length ) { lineSpark.sparkline('html', defaultOpts); }
  }

  function barSparks(el, opts) {
    var barSpark = jQuery(el);

    var defaultOpts = {
      type: 'bar',
      barWidth: 8,
      barSpacing: 6,
      barColor: '#ffca28',
      tooltipPrefix: '',
      tooltipSuffix: ' Tickets',
      tooltipFormat: '{{prefix}}{{value}}{{suffix}}',
      enableTagOptions: true
    };

    for (var attrname in opts) { defaultOpts[attrname] = opts[attrname]; }

    if ( barSpark.length ) { barSpark.sparkline('html', defaultOpts); }
  }

  function pieSparks(el, opts) {
    var pieSpark = jQuery(el);

    var defaultOpts = {
      type: 'pie',
      width: '80px',
      height: '80px',
      sliceColors: ['#ffca28','#9ccc65', '#42a5f5','#ef5350'],
      highlightLighten: 1.1,
      tooltipPrefix: '',
      tooltipSuffix: ' Tickets',
      tooltipFormat: '{{prefix}}{{value}}{{suffix}}'
    };

    for (var attrname in opts) { defaultOpts[attrname] = opts[attrname]; }

    if ( pieSpark.length ) { pieSpark.sparkline('html', defaultOpts); }
  }

  function triSparks(el, opts) {
    var triSpark    = jQuery(el);

    var defaultOpts = {
      type: 'tristate',
      barWidth: 8,
      barSpacing: 6,
      height: '110px',
      posBarColor: '#9ccc65',
      negBarColor: '#ef5350'
    };

    for (var attrname in opts) { defaultOpts[attrname] = opts[attrname]; }

    if ( triSpark.length ) { triSpark.sparkline('html', defaultOpts); }
  }

  function initSparklineDemo() {
    lineSparks('.spark-line-1', {
      lineColor: '#9ccc65',
      fillColor: '#9ccc65',
      tooltipSuffix: ' Tickets',
      tooltipPrefix: '$ ',
    })

    lineSparks('.spark-line-2', {
      lineColor: '#9ccc65',
      fillColor: '#9ccc65',
      tooltipPrefix: '$ ',
      tooltipSuffix: ''
    })


    lineSparks('.spark-line-3', {
      lineColor: '#9ccc65',
      fillColor: '#9ccc65',
      tooltipPrefix: '$ ',
      tooltipSuffix: ''
    })

    pieSparks('.spark-pie-1', {

    })

    pieSparks('.spark-pie-2', {

    })

    pieSparks('.spark-pie-3', {

    })

    barSparks('.spark-bar-1', {
      barColor: '#9ccc65',
      tooltipPrefix: '$ ',
      tooltipSuffix: ''
    })

    barSparks('.spark-bar-2', {
      barColor: '#9ccc65',
      tooltipPrefix: '$ ',
      tooltipSuffix: ''
    })

    barSparks('.spark-bar-3', {
      barColor: '#9ccc65',
      tooltipPrefix: '$ ',
      tooltipSuffix: ''
    })

    triSparks('.spark-tri-1',{

    })

    triSparks('.spark-tri-2',{

    })

    triSparks('.spark-tri-3',{

    })
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('demo-sparklines') && initSparklineDemo.call(this)
  })

})()

