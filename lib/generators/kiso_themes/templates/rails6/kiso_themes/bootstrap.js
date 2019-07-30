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

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('bootstrap') && initBootstrap.call(this)
  })

})()

