
window.RRT || (window.RRT = {});

// Get the features array
RRT.jsLibs = function() {
  var jsLibs = $('body').data('js-libs');
  var jsLibsArray = [];
  if(jsLibs) {
    jsLibsArray = jsLibs.split(' ');
  }
  return jsLibsArray;
};

RRT.hookOnPageLoad = function( callback ) {
  if (typeof window.Turbolinks === 'object') {
    $(document).on('turbolinks:load', function() { callback(); });
  } else {
    $(function() { callback(); });
  }
}

RRT.jsLibIsActive = function( jsLibName ) {
  return $.inArray(jsLibName, RRT.jsLibs()) >= 0
}

RRT.getRootCssVariable = function( varName ) {
  return RRT.getCssVariable( 'body', varName )
}

RRT.getCssVariable = function( el, varName ) {
  var elStyles = window.getComputedStyle(document.querySelector(el));
  return elStyles.getPropertyValue(varName);
}

RRT.debounce = function (func, wait, immediate) {
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
