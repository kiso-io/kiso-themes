import DataGenerator from './data_generator';

if(window.Chart) {
  Chart.defaults.global.defaultFontColor              = '#555555';
  Chart.defaults.scale.gridLines.color                = "rgba(0,0,0,.04)";
  Chart.defaults.scale.gridLines.zeroLineColor        = "rgba(0,0,0,.1)";
  Chart.defaults.scale.ticks.beginAtZero              = true;
  Chart.defaults.global.elements.line.borderWidth     = 2;
  Chart.defaults.global.elements.point.radius         = 5;
  Chart.defaults.global.elements.point.hoverRadius    = 7;
  Chart.defaults.global.tooltips.cornerRadius         = 3;
  Chart.defaults.global.legend.labels.boxWidth        = 12;
}

(function() {
  function flotRealtime() {
    if ($('.flot-realtime').length === 0) {
      return;
    }

    var dataGenerator = new DataGenerator(200);
    var plot = $.plot($('.flot-realtime'), [dataGenerator.getRandomizedData()], {
      series: {
        shadowSize: 0
      },
      colors: [
        KisoThemes.getRootCssVariable('--metric-chart-fill-color'),
        KisoThemes.getRootCssVariable('--metric-chart-fill-color-1'),
        KisoThemes.getRootCssVariable('--metric-chart-fill-color-2')
      ],
      lines: {
        fill: true,
        fillColor: {
          colors: [{opacity: 1}, {opacity: .3}]
        }
      },
      yaxis: {
        min: 0,
        max: 100
      },
      xaxis: {
        show: false
      }
    });

    function update() {
      plot.setData([dataGenerator.getRandomizedData()]);
      plot.draw();

      if (!Modernizr.touch) {
        window.requestAnimationFrame(update);
      } else {
        setTimeout(update, 1000);
      }
    }

    update();
  }

  function displayRandomMetricCharts() {
    var randomMetricGraphs = jQuery('.metric-random-graph');

    if(randomMetricGraphs.length > 0) {
      randomMetricGraphs.each(function(i, graph) {
        var isDetailGraph = $(graph).hasClass('detail-graph')

        var data = Array.apply(null, Array(10)).map(function() { return Math.floor(Math.random() * 100 % 100); })
        var lablels = null;

        if(isDetailGraph) {
          var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
          var endDate = new Date()
          var startDate = new Date(new Date().setDate(endDate.getDate()-30))
          labels = Array(Math.floor((endDate - startDate) / 86400000) + 1).fill().map( function(_, idx) {
            var d = new Date(startDate.getTime() + idx * 86400000)
            return monthNames[d.getMonth()] + ' ' + d.getDate()
          })
          data = Array.apply(null, Array(31)).map(function() { return Math.floor(Math.random() * 100 % 100); })
        }

        var metricChartFillColor = KisoThemes.getRootCssVariable('--metric-chart-fill-color');
        var metricChartBorderColor = KisoThemes.getRootCssVariable('--metric-chart-border-color');

        var graphData = {
          datasets: [{
            fill: true,
            backgroundColor: metricChartFillColor,
            borderColor: metricChartBorderColor,
            borderWidth: 4,
            pointRadius: 0,
            data: data
          }]
        };

        if(isDetailGraph) {
          graphData.labels = labels
          graphData.datasets[0].pointBackgroundColor = 'rgba(66,165,245,1)';
          graphData.datasets[0].pointBorderColor= '#fff';
          graphData.datasets[0].pointHoverBackgroundColor= '#fff';
          graphData.datasets[0].pointHoverBorderColor= 'rgba(66,165,245,1)';
          graphData.datasets[0].pointRadius = 4;
          graphData.datasets[0].borderWidth = 2;
        }

        new Chart(graph, { type: 'line', data: graphData, options: {
          maintainAspectRatio: false,
          responsive: true,
          legend: {
            display: false
          },
          scales: {
            xAxes: [{
              display: isDetailGraph,
              gridLines: {
                    display: isDetailGraph,
                    drawBorder: false,
                    drawOnChartArea: true,
                    drawTicks: isDetailGraph,
                }
            }],

            yAxes: [{
              display: isDetailGraph,
              gridLines: {
                    display: isDetailGraph,
                    drawBorder: false,
                    drawOnChartArea: true,
                    drawTicks: isDetailGraph,
                }
            }]
          }
        } })
      });
    }

  }

  function salesVsRefunds() {
    var chartLinesCon  = jQuery('.sales-vs-refunds');

    var metricChartFillColor = KisoThemes.getRootCssVariable('--metric-chart-fill-color');
    var metricChartFillColorAlt = KisoThemes.getRootCssVariable('--metric-chart-fill-color-1');
    var metricChartBorderColor = KisoThemes.getRootCssVariable('--metric-chart-border-color');

    var chartLinesBarsRadarData = {
      labels: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'],
      datasets: [
        {
        label: 'Refunds',
        fill: true,
        backgroundColor: metricChartBorderColor,
        borderColor: metricChartFillColor,
        pointBackgroundColor: 'rgba(66,165,245,1)',
        pointBorderColor: '#fff',
        pointHoverBackgroundColor: '#fff',
        pointHoverBorderColor: 'rgba(66,165,245,1)',
        data: [19, 20, 8, 32, 100, 15, 99]
      },
      {
        label: 'Sales',
        fill: true,
        backgroundColor: metricChartFillColorAlt,
        borderColor: metricChartBorderColor,
        pointBackgroundColor: metricChartFillColorAlt,
        pointBorderColor: '#fff',
        pointHoverBackgroundColor: '#fff',
        pointHoverBorderColor: 'rgba(66,165,245,1)',
        data: [200, 192, 220, 240, 200, 131, 126]
      }
      ]
    };

    if(chartLinesCon.length > 0) {
      new Chart(chartLinesCon, { type: 'line', data: chartLinesBarsRadarData });
    }


  }
  function initDashboardDemo() {
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
            to: value + (Math.random()*100)
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


    displayRandomMetricCharts();
    flotRealtime();
    salesVsRefunds();
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('demo-dashboard') && initDashboardDemo.call(this)
  })
})()

