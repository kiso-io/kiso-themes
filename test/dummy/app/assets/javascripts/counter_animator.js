var CounterAnimator = function( el, targetValue ) {
  this.el = el;
  this.targetValue = targetValue;
}

CounterAnimator.prototype.numberWithCommas = function(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

CounterAnimator.prototype.animateTo = function(newValue) {
  var div_by = 100,
      $display = $(this.el),
      run_count = 1,
      int_speed = 24,
      initialVal = parseInt($(this.el).text().replace(/,/g, ''));

    if ($display.hasClass('animating')) {
      return;
    }

    var self = this;

    var int = setInterval(function() {
        $display.addClass('animating');
        speed = Math.round(newValue / div_by);

        if(run_count < div_by ){
            $display.text( self.numberWithCommas((speed * run_count)) );
            run_count++;
        } else if(parseInt($display.text().replace(/,/g, '')) < newValue) {
            var curr_count = parseInt($display.text().replace(/,/g, '')) + 1;
            $display.text(self.numberWithCommas(curr_count));
        } else {
            $display.removeClass('animating');
            clearInterval(int);
        }
    }, int_speed);

}