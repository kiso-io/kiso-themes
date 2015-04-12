function flotMetric(el, data, yaxis, options) {
  if( el[0] === undefined ) {
    return;
  }

  options = $.extend({
      type: 'area',
      lineWidth: 1
  }, options);

  var series = {
      shadowSize: 0
  };

  series.lines = {
      lineWidth: 3,
      show: true,
      fill: true
  };

  $.plot(el, [{
    label: 'Data 1',
    data: data,
    color: '#C9E3F5'
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
};

function rickshawBars() {
  if( $('#rickshaw-bars')[0] === undefined ) {
    return;
  }

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
        color: "#D13B47",
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
  if( $('#realtime')[0] === undefined ) {
    return;
  }

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
  if( $('#map_canvas_1')[0] === undefined ) {
    return;
  }

  var oldMarker;

  var map = new GMaps({
      div: '#map_canvas_1',
      lat: 0,
      lng: 0,
      disableDefaultUI: true,
      scaleControl: false,
        scrollwheel: false,
        disableDoubleClickZoom: true,
      zoomControl : true,
      zoomControlOpt: {
          style : 'SMALL',
          position: 'TOP_RIGHT'
      },
      height: '494px',
      zoom: 1
  });

  function removeMarkers() {
    map.removeMarkers();
  }

  function update() {
    map.addMarker({
      lat: Math.random() * 280,
      lng: Math.random() * 360
    });

    setTimeout(update, Math.random() * 1000);
    setTimeout(removeMarkers, 10000);
  }

  update();
});