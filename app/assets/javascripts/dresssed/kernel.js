
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
    $(function() { callback(); });
  }
}

Dresssed.jsLibIsActive = function( jsLibName ) {
  return $.inArray(jsLibName, Dresssed.jsLibs()) >= 0
}

Dresssed.debounce = function (func, wait, immediate) {
	var timeout;
	return function() {
		var context = this, args = arguments;
		var later = function() {
			timeout = null;
			if (!immediate) func.apply(context, args);
		};
		var callNow = immediate && !timeout;
		clearTimeout(timeout);
		timeout = setTimeout(later, wait);
		if (callNow) func.apply(context, args);
	};
};
