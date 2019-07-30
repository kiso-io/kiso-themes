//= require vendor/bootstrap_switch/bootstrap_switch

(function() {

  function initBootstrapSwitch() {
    $('.bootstrap-switch').each(function() {
      $this = $(this);
      data_on_label = $this.data('on-label') || '';
      data_off_label = $this.data('off-label') || '';

      $this.bootstrapSwitch({
        onText: data_on_label,
        offText: data_off_label
      });
    });
  }

  KisoThemes.hookOnPageLoad( function() {
    KisoThemes.jsLibIsActive('bs-switch') && initBootstrapSwitch.call(this)
  })

})()

