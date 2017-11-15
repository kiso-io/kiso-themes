
//= require jqvectormaps/jquery-jvectormap
//= require jqvectormaps/maps/jquery-jvectormap-au-mill-en
//= require jqvectormaps/maps/jquery-jvectormap-cn-mill-en
//= require jqvectormaps/maps/jquery-jvectormap-de-mill-en
//= require jqvectormaps/maps/jquery-jvectormap-europe-mill-en
//= require jqvectormaps/maps/jquery-jvectormap-fr-mill-en
//= require jqvectormaps/maps/jquery-jvectormap-in-mill-en
//= require jqvectormaps/maps/jquery-jvectormap-us-aea-en
//= require jqvectormaps/maps/jquery-jvectormap-world-mill-en
//= require jqvectormaps/maps/jquery-jvectormap-za-mill-en
//= require jqvectormaps/maps/jquery-jvectormap-ca-mill

(function() {

  function initVectorMap() {
  }

  RRT.hookOnPageLoad( function() {
    RRT.jsLibIsActive('vectormaps') && initVectorMap.call(this)
  })

})()

