//= require vendor/metis_menu/metis_menu

(function() {
  function initMetisMenu() {
    $('.nav-side-menu').metisMenu({
      triggerElement: '.nav-link', // bootstrap 4
      parentTrigger: '.nav-item', // bootstrap 4
      collapseInClass: 'show'
    });
  }

  RRT.hookOnPageLoad( function() {
    RRT.jsLibIsActive('metis') && initMetisMenu.call(this)
  })
})()

