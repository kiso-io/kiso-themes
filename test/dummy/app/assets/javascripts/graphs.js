//= require graph_data_generator

function rickshawBars() {
  var seriesData = [ [], [] ];
  var random = new Rickshaw.Fixtures.RandomData(50);

  for (var i = 0; i < 50; i++) {
    random.addData(seriesData);
  }

  var graph = new Rickshaw.Graph( {
    element: document.getElementById("rickshaw-bars"),
    height: 200,
    renderer: 'bar',
    series: [
      {
        color: "#c72929",
        data: seriesData[0],
      }, {
        color: "#90caf9",
        data: seriesData[1],
      }
    ]
  } );

  graph.render();

  $(window).on('resize', function(){
    graph.configure({
      width: $("#rickshaw-bars").parent('.panel-body').width(),
      height: 200
    });
    graph.render();
  });

  var hoverDetail = new Rickshaw.Graph.HoverDetail( { graph: graph } );
}

function flotRealtime() {
  var dataGenerator = new DataGenerator(200);
  var plot = $.plot("#realtime", [ dataGenerator.getRandomizedData() ], {
    series: {
      shadowSize: 0
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
    setTimeout(update, 24);
  }

  update();
}

function flotMetric(el, data, yaxis, options) {
  options = $.extend({
      type: 'area',
      lineWidth: 1
  }, options);

  var series = {
      shadowSize: 0
  };

  switch (options.type) {
      case 'bar':
          series.bars = {
              show: true,
              align: 'center',
              lineWidth: 1,
              fill: true,
              fillColor: null
          };
          break;
      case 'area-points':
          series.lines = {
              lineWidth: 2,
              show: true,
              fill: true
          };
          series.points = {
              show: true,
              lineWidth: 1,
              fill: true,
              fillColor: '#ffffff',
              symbol: 'circle',
              radius: 3
          };
          break;
      default:
          series.lines = {
              lineWidth: 3,
              show: true,
              fill: true
          };
  }

  $.plot(el, [{
    label: 'Data 1',
    data: data,
    color: options.color
  }], {
    series: series,
    grid: {
        show: false,
        borderWidth: 0
    },
    yaxis: yaxis,
    xaxis: {
        tickDecimals: 0
    },
    legend: {
        show: false
    }
  });
}

$(document).ready(function(){
  flotRealtime();
  rickshawBars();

  flotMetric($('#metric-monthly-earnings'), [
      [0, 4],
      [1, 8],
      [2, 14],
      [3, 16],
      [4, 12],
      [5, 26],
      [6, 29],
      [7, 32]
  ]);

  flotMetric($('#metric-cancellations'), [
      [0, 0],
      [1, 0],
      [2, 1],
      [3, 0],
      [4, 2],
      [5, 1],
      [6, 0],
      [7, 0]
  ]);
});
