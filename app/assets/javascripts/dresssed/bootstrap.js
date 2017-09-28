//= require bootstrap/bootstrap

(function() {

  function initBootstrap() {
    $('[data-toggle="popover"]').popover({
      container: 'body'
    });

    $('[data-toggle="tooltip"]').tooltip({
      container: 'body'
    });
  }

  Dresssed.hookOnPageLoad( function() {
    Dresssed.jsLibIsActive('bootstrap') && initBootstrap.call(this)
  })

})()

