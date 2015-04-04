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

$(document).ready(function(){
  flotRealtime();
  rickshawBars();
});
