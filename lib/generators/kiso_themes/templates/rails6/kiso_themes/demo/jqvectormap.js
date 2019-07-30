(function() {

  function makeJqvMap(el, type, opts) {
    var defaultOpts = {
      map: type,
      backgroundColor: '#ffffff',
      regionStyle: {
        initial: {
          fill: '#42a5f5',
          'fill-opacity': 1,
          stroke: 'none',
          'stroke-width': 0,
          'stroke-opacity': 1
        },
        hover: {
          'fill-opacity': .8,
          cursor: 'pointer'
        }
      }
    }

    for (var attrname in opts) { defaultOpts[attrname] = opts[attrname]; }
    el.vectorMap(defaultOpts)
  }

  function initJqvDemoMaps() {
    makeJqvMap($('.jqv-world-map'), 'world_mill_en')

    makeJqvMap($('.jqv-inverse-world-map'), 'world_mill_en', {
      backgroundColor: '#193341',
      regionStyle: {
        initial: {
          fill: '#3C6A81',
          'fill-opacity': 0.8,
          stroke: 'none',
          'stroke-width': 1,
          'stroke-opacity': 1
        },
        hover: {
          fill: '#FFF',
          'fill-opacity': 1
        }
      }
    })

    makeJqvMap($('.jqv-canada-map'), 'ca_mill')

    makeJqvMap($('.jqv-europe-map'), 'europe_mill_en')
    makeJqvMap($('.jqv-us-map'), 'us_aea_en')
    makeJqvMap($('.jqv-india-map'), 'in_mill_en')
    makeJqvMap($('.jqv-china-map'), 'cn_mill_en')
    makeJqvMap($('.jqv-australia-map'), 'au_mill_en')
    makeJqvMap($('.jqv-southafrica-map'), 'za_mill_en')
    makeJqvMap($('.jqv-france-map'), 'fr_mill_en')
    makeJqvMap($('.jqv-germany-map'), 'de_mill_en')

  }


  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('demo-jqvectormap') && initJqvDemoMaps.call(this)
  })

})()

