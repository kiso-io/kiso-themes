//= require graph_data_generator

$(document).ready(function(){
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
    setTimeout(update, 35);
  }

  update();
});
