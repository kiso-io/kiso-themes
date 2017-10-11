
(function() {
  function dashboardGmap() {
    if ($('#gmapDemo')[0] === undefined || !Dresssed.jsLibIsActive('gmaps')) {
      return;
    }

    var oldMarker;

    var map = new GMaps({
      div: '#gmapDemo',
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
  }

  function makeGmap(el, type, opts) {
    var satelliteGmap = $(el)
    if(satelliteGmap.length === 0) {
      return
    }

    var defaultOpts = {
      div: el,
      lat: '55.855573',
      lng: '-4.3728844',
      mapType: type,
      disableDefaultUI: true,
      scaleControl: false,
      scrollwheel: false,
      disableDoubleClickZoom: false,
      zoomControl: true,
      zoomControlOpt: {
        style: 'SMALL',
        position: 'TOP_RIGHT'
      },
      height: '485px',
      zoom: 5
    }


    for (var attrname in opts) { defaultOpts[attrname] = opts[attrname]; }

    var map = new GMaps(defaultOpts);

    return map
  }

  function createStreetview( el, lat, long, heading, pitch ) {
    if ($(el).length) {
      return new GMaps.createPanorama({
        el: el,
        lat: lat,
        lng: long,
        pov: { heading: heading, pitch: pitch },
        scrollwheel: false
      });
    }
  }

  function drawMapOverlay(map, lat, long, content) {
    map.drawOverlay({
      lat: lat,
      lng: long,
      content: content
    });
  }

  function initGmapsDemo() {
    dashboardGmap();

    makeGmap('.gmap-satellite', 'satellite');
    makeGmap('.gmap-terrain', 'terrain');
    makeGmap('.gmap-hybrid', 'hybrid');
    makeGmap('.gmap-default', 'roadmap');
    createStreetview('#gmap-streetview', '55.8611768', '-4.2538145', 250, 9);

    var overlayMap = makeGmap('.gmap-overlay', 'satellite')
    drawMapOverlay(overlayMap, '55.855573', '-4.3728844','<div class="alert alert-danger">ZOMBIES ALERT</div>')

    var markerMap = makeGmap('.gmap-markers', 'roadmap');
    markerMap.addMarker({
      lat: 55.855573,
      lng: -4.3728844,
      title: 'Zombies',
      animation: google.maps.Animation.DROP,
      click: function(e) {
        alert('You clicked in this marker');
      }
    });


    var polyMap = makeGmap('.gmap-polygons', 'roadmap', {zoom: 15, lat: '55.863340', lng:'-4.254116'});
    var path = [[55.864894, -4.261562], [55.864581, -4.249031], [55.861907, -4.252507],	[55.862678, -4.262678]];

    polygon = polyMap.drawPolygon({
      paths: path, // pre-defined polygon shape
      strokeColor: '#BBD8E9',
      strokeOpacity: 1,
      strokeWeight: 3,
      fillColor: '#BBD8E9',
      fillOpacity: 0.6
    });
  }

  Dresssed.hookOnPageLoad( function() {
    Dresssed.jsLibIsActive('demo-gmaps') && initGmapsDemo.call(this)
  })

})()
