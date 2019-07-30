import DataGenerator from './data_generator';

(function() {

  if(window.Chart) {
    Chart.defaults.global.defaultFontColor              = '#555555';
    Chart.defaults.scale.gridLines.color                = "rgba(0,0,0,.04)";
    Chart.defaults.scale.gridLines.zeroLineColor        = "rgba(0,0,0,.1)";
    Chart.defaults.scale.ticks.beginAtZero              = true;
    Chart.defaults.global.elements.line.borderWidth     = 2;
    Chart.defaults.global.elements.point.radius         = 5;
    Chart.defaults.global.elements.point.hoverRadius    = 7;
    Chart.defaults.global.tooltips.cornerRadius         = 3;
    Chart.defaults.global.legend.labels.boxWidth        = 6;
  }

  function lineCharts(el, type) {
    var chartLinesCon  = jQuery(el);

    var data = {
      labels: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'],
      datasets: [
        {
        label: 'Refunds',
        fill: true,
        backgroundColor: '#81A2D0',
        borderColor: 'rgba(66,165,245,1)',
        pointBackgroundColor: 'rgba(66,165,245,1)',
        pointBorderColor: '#fff',
        pointHoverBackgroundColor: '#fff',
        pointHoverBorderColor: 'rgba(66,165,245,1)',
        data: [19, 20, 8, 32, 100, 15, 99]
      },
      {
        label: 'Sales',
        fill: true,
        backgroundColor: '#e9f4fb',
        borderColor: '#A3D9FE',
        pointBackgroundColor: '#A3D9FE',
        pointBorderColor: '#fff',
        pointHoverBackgroundColor: '#fff',
        pointHoverBorderColor: 'rgba(66,165,245,1)',
        data: [200, 192, 220, 240, 200, 131, 126]
      }
      ]
    };

    if(chartLinesCon.length > 0) {
      new Chart(chartLinesCon, { type: type, data: data });
    }
  }

  function roundChart(el, type) {
    var chart  = jQuery(el);

    var data = {
      labels: [
        'New Issues',
        'Closed Issues',
        'Reopened Issues'
      ],
      datasets: [{
        data: [
          67,
          23,
          10
        ],
        backgroundColor: [
          'rgba(156,204,101,1)',
          'rgba(255,202,40,1)',
          'rgba(239,83,80,1)'
        ],
        hoverBackgroundColor: [
          'rgba(156,204,101,.5)',
          'rgba(255,202,40,.5)',
          'rgba(239,83,80,.5)'
        ]
      }]
    };

    if(chart.length > 0) {
      new Chart(chart, { type: type, data: data });
    }
  }

  function initChartJsDemo() {
    lineCharts('.sales-vs-refunds', 'line');
    lineCharts('.sales-vs-refunds-bars', 'bar');
    lineCharts('.demo-radar', 'radar');
    roundChart('.demo-pie', 'pie')
    roundChart('.demo-polar', 'polarArea')
    roundChart('.demo-doughnut', 'doughnut')

    lineCharts('[data-chartjs-line-demo]', 'line');
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('demo-chartjs') && initChartJsDemo.call(this)
  })
})()

