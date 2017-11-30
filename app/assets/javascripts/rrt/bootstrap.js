//= require vendor/bootstrap/bootstrap

(function() {

  function initBootstrap() {
    $('[data-toggle="popover"]').popover({
      container: 'body'
    });

    $('[data-toggle="tooltip"]').tooltip({
      container: 'body'
    });
  }

  RRT.hookOnPageLoad( function() {
    RRT.jsLibIsActive('bootstrap') && initBootstrap.call(this)
  })

})()

