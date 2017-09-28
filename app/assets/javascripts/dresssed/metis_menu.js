//= require metis_menu/metis_menu

(function() {
  function initMetisMenu() {
    $('.nav-side-menu').metisMenu({
      triggerElement: '.nav-link', // bootstrap 4
      parentTrigger: '.nav-item', // bootstrap 4
      collapseInClass: 'show'
    });
  }

  Dresssed.hookOnPageLoad( function() {
    Dresssed.jsLibIsActive('metis') && initMetisMenu.call(this)
  })
})()

