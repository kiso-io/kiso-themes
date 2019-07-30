
import DataGenerator from './data_generator';

(function() {

  function initFlotDemo() {
    var dataEarnings    = [[1, 1500], [2, 1700], [3, 1400], [4, 1900], [5, 2500], [6, 2300], [7, 2700], [8, 3200], [9, 3500], [10, 3260], [11, 4100], [12, 4600]];
    var dataSales       = [[1, 500], [2, 600], [3, 400], [4, 750], [5, 1150], [6, 950], [7, 1400], [8, 1700], [9, 1800], [10, 1300], [11, 1750], [12, 2900]];

    var dataSalesBefore = [[1, 500], [4, 600], [7, 1000], [10, 600], [13, 800], [16, 1200], [19, 1500], [22, 1600], [25, 2500], [28, 2700], [31, 3500], [34, 4500]];
    var dataSalesAfter  = [[2, 900], [5, 1200], [8, 2000], [11, 1200], [14, 1600], [17, 2400], [20, 3000], [23, 3200], [26, 5000], [29, 5400], [32, 7000], [35, 9000]];

    var dataMonths      = [[1, 'Jan'], [2, 'Feb'], [3, 'Mar'], [4, 'Apr'], [5, 'May'], [6, 'Jun'], [7, 'Jul'], [8, 'Aug'], [9, 'Sep'], [10, 'Oct'], [11, 'Nov'], [12, 'Dec']];
    var dataMonthsBars  = [[2, 'Jan'], [5, 'Feb'], [8, 'Mar'], [11, 'Apr'], [14, 'May'], [17, 'Jun'], [20, 'Jul'], [23, 'Aug'], [26, 'Sep'], [29, 'Oct'], [32, 'Nov'], [35, 'Dec']];

    function flotRealtime(el) {
      var dataGenerator = new DataGenerator(200);
      var plot = $.plot(el, [dataGenerator.getRandomizedData()], {
        series: {
          shadowSize: 0
        },
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
          setTimeout(function() { window.requestAnimationFrame(update)}, 24);
        } else {
          setTimeout(function() { window.requestAnimationFrame(update) }, 1000);
        }
      }

      update();
    }

    function flotLine(el) {

      $.plot(el,
             [
               {
               label: 'Earnings',
               data: dataEarnings,
               lines: {
                 show: true,
                 fill: true,
                 fillColor: {
                   colors: [{opacity: .7}, {opacity: .7}]
                 }
               },
               points: {
                 show: true,
                 radius: 5
               }
             },
             {
               label: 'Sales',
               data: dataSales,
               lines: {
                 show: true,
                 fill: true,
                 fillColor: {
                   colors: [{opacity: .5}, {opacity: .5}]
                 }
               },
               points: {
                 show: true,
                 radius: 5
               }
             }
             ],
             {
               colors: ['#ffca28', '#555555'],
               legend: {
                 show: true,
                 position: 'nw',
                 backgroundOpacity: 0
               },
               grid: {
                 borderWidth: 0,
                 hoverable: true,
                 clickable: true
               },
               yaxis: {
                 tickColor: '#ffffff',
                 ticks: 3
               },
               xaxis: {
                 ticks: dataMonths,
                 tickColor: '#f5f5f5'
               }
             }
            );
    }

    function flotStacked(el) {
      $.plot(el,
             [
               {
               label: 'Sales',
               data: dataSales
             },
             {
               label: 'Earnings',
               data: dataEarnings
             }
             ],
             {
               colors: ['#555555', '#26c6da'],
               series: {
                 stack: true,
                 lines: {
                   show: true,
                   fill: true
                 }
               },
               lines: {show: true,
                 lineWidth: 0,
                 fill: true,
                 fillColor: {
                   colors: [{opacity: 1}, {opacity: 1}]
                 }
               },
               legend: {
                 show: true,
                 position: 'nw',
                 sorted: true,
                 backgroundOpacity: 0
               },
               grid: {
                 borderWidth: 0
               },
               yaxis: {
                 tickColor: '#ffffff',
                 ticks: 3
               },
               xaxis: {
                 ticks: dataMonths,
                 tickColor: '#f5f5f5'
               }
             }
            );
    }

    function flotBars(el) {
      $.plot(el,
             [
               {
               label: 'Sales Before Release',
               data: dataSalesBefore,
               bars: {
                 show: true,
                 lineWidth: 0,
                 fillColor: {
                   colors: [{opacity: .75}, {opacity: .75}]
                 }
               }
             },
             {
               label: 'Sales After Release',
               data: dataSalesAfter,
               bars: {
                 show: true,
                 lineWidth: 0,
                 fillColor: {
                   colors: [{opacity: .75}, {opacity: .75}]
                 }
               }
             }
             ],
             {
               colors: ['#ef5350', '#9ccc65'],
               legend: {
                 show: true,
                 position: 'nw',
                 backgroundOpacity: 0
               },
               grid: {
                 borderWidth: 0
               },
               yaxis: {
                 ticks: 3,
                 tickColor: '#f5f5f5'
               },
               xaxis: {
                 ticks: dataMonthsBars,
                 tickColor: '#f5f5f5'
               }
             }
            );
    }

    function flotPie(el) {
      $.plot(el,
             [
               {
               label: 'Sales',
               data: 15
             },
             {
               label: 'Tickets',
               data: 12
             },
             {
               label: 'Earnings',
               data: 73
             }
             ],
             {
               colors: ['#26c6da', '#ffca28', '#9ccc65'],
               legend: {show: false},
               series: {
                 pie: {
                   show: true,
                   radius: 1,
                   label: {
                     show: true,
                     radius: 2/3,
                     formatter: function(label, pieSeries) {
                       return '<div class="flot-pie-label">' + label + '<br>' + Math.round(pieSeries.percent) + '%</div>';
                     },
                     background: {
                       opacity: .75,
                       color: '#000000'
                     }
                   }
                 }
               }
             }
            );
    }

    flotRealtime('.demo-realtime')
    flotLine('.demo-line')
    flotStacked('.demo-stacked')
    flotBars('.demo-bars')
    flotPie('.demo-pie')
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('demo-flot') && initFlotDemo.call(this)
  })
})()

