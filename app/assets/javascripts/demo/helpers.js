function flotMetric(el, data, yaxis, options) {
  if (el[0] === undefined) {
    return;
  }

  options = $.extend(
    {
    type: 'area',
    lineWidth: 1
  },
  options
  );

  var series = {
    shadowSize: 0
  };

  series.lines = {
    lineWidth: 3,
    show: true,
    fill: true
  };

  $.plot(
    el,
    [
      {
      label: 'Data 1',
      data: data,
      color: '#C9E3F5'
    }
    ],
    {
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
    }
  );
}

function flotRealtime() {
  if ($('#realtime')[0] === undefined) {
    return;
  }

  var dataGenerator = new DataGenerator(200);
  var plot = $.plot('#realtime', [dataGenerator.getRandomizedData()], {
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

    if (!Modernizr.touch) {
      setTimeout(update, 24);
    } else {
      setTimeout(update, 1000);
    }
  }

  update();
}

$(document).ready(function() {
  if ($('#map_canvas_1')[0] === undefined) {
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
    zoomControl: true,
    zoomControlOpt: {
      style: 'SMALL',
      position: 'TOP_RIGHT'
    },
    height: '485px',
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

    if (!Modernizr.touch) {
      setTimeout(update, Math.random() * 1000);
      setTimeout(removeMarkers, 10000);
    }
  }

  update();
});

function salesVsRefunds() {
  // Set Global Chart.js configuration
  Chart.defaults.global.defaultFontColor              = '#555555';
  Chart.defaults.scale.gridLines.color                = "rgba(0,0,0,.04)";
  Chart.defaults.scale.gridLines.zeroLineColor        = "rgba(0,0,0,.1)";
  Chart.defaults.scale.ticks.beginAtZero              = true;
  Chart.defaults.global.elements.line.borderWidth     = 2;
  Chart.defaults.global.elements.point.radius         = 5;
  Chart.defaults.global.elements.point.hoverRadius    = 7;
  Chart.defaults.global.tooltips.cornerRadius         = 3;
  Chart.defaults.global.legend.labels.boxWidth        = 12;

  var chartLinesCon  = jQuery('.sales-vs-refunds');

  var chartLinesBarsRadarData = {
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
    new Chart(chartLinesCon, { type: 'line', data: chartLinesBarsRadarData });
  }


}
