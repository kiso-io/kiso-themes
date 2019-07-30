
window.KisoThemes || (window.KisoThemes = {});

// Get the features array
KisoThemes.jsLibs = function() {
  var jsLibs = $('body').data('js-libs');
  var jsLibsArray = [];
  if(jsLibs) {
    jsLibsArray = jsLibs.split(' ');
  }
  return jsLibsArray;
};

KisoThemes.hookOnPageLoad = function( callback ) {
  if (typeof window.Turbolinks === 'object') {
    $(document).on('turbolinks:load', function() { callback(); });
  } else {
    $(function() { callback(); });
  }
}

KisoThemes.jsLibIsActive = function( jsLibName ) {
  return $.inArray(jsLibName, KisoThemes.jsLibs()) >= 0
}

KisoThemes.getRootCssVariable = function( varName ) {
  return KisoThemes.getCssVariable( 'body', varName )
}

KisoThemes.getCssVariable = function( el, varName ) {
  var elStyles = window.getComputedStyle(document.querySelector(el));
  return elStyles.getPropertyValue(varName);
}

KisoThemes.debounce = function (func, wait, immediate) {
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
