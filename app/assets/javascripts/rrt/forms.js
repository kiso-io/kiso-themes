(function() {
  function initForms() {
    $('.form-control').on('focus', function() {
      $(this).parent('.input-group').addClass('input-group-focus');
    }).on('blur', function() {
      $(this).parent('.input-group').removeClass('input-group-focus');
    });
  }

  RRT.hookOnPageLoad( function() {
    RRT.jsLibIsActive('forms') && initForms.call(this)
  })
})()
