
//= require vendor/jqvectormaps/jquery-jvectormap
//= require vendor/jqvectormaps/maps/jquery-jvectormap-au-mill-en
//= require vendor/jqvectormaps/maps/jquery-jvectormap-cn-mill-en
//= require vendor/jqvectormaps/maps/jquery-jvectormap-de-mill-en
//= require vendor/jqvectormaps/maps/jquery-jvectormap-europe-mill-en
//= require vendor/jqvectormaps/maps/jquery-jvectormap-fr-mill-en
//= require vendor/jqvectormaps/maps/jquery-jvectormap-in-mill-en
//= require vendor/jqvectormaps/maps/jquery-jvectormap-us-aea-en
//= require vendor/jqvectormaps/maps/jquery-jvectormap-world-mill-en
//= require vendor/jqvectormaps/maps/jquery-jvectormap-za-mill-en
//= require vendor/jqvectormaps/maps/jquery-jvectormap-ca-mill

(function() {

  function initVectorMap() {
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('vectormaps') && initVectorMap.call(this)
  })

})()

