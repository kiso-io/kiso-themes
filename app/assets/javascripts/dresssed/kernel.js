
window.Dresssed || (window.Dresssed = {});

// Get the features array
Dresssed.jsLibs = function() {
  var jsLibs = $('body').data('js-libs');
  var jsLibsArray = [];
  if(jsLibs) {
    jsLibsArray = jsLibs.split(' ');
  }
  return jsLibsArray;
};

Dresssed.hookOnPageLoad = function( callback ) {
  if (typeof window.Turbolinks === 'object') {
    $(document).on('turbolinks:load', function() { callback(); });
  } else {
    $(document).ready(function() { callback(); });
  }
}

Dresssed.jsLibIsActive = function( jsLibName ) {
  return $.inArray(jsLibName, Dresssed.jsLibs()) >= 0
}
