//= require vendor/metis_menu/metis_menu

(function() {
  function initMetisMenu() {
    $('.nav-side-menu').metisMenu({
      triggerElement: '.nav-link', // bootstrap 4
      parentTrigger: '.nav-item', // bootstrap 4
      collapseInClass: 'show'
    });
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('metis') && initMetisMenu.call(this)
  })
})()

