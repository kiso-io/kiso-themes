// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require dresssed
//= require docs
//= require counters

$(document).ready(function(){
  if(Modernizr.touch) {
    $('#menu-content').slimScroll({
         destroy: 'true'
     });
  }

  $('.size-mobile').on('click', function(){
    sizeiframe(320, true);
  });

  $('.size-tablet').on('click', function(){
    sizeiframe(768, true);
  });

  $('.size-laptop').on('click', function(){
    sizeiframe(document.body.clientWidth, true);
  })

  if( !Modernizr.touch ) {
    sizeiframe(document.body.clientWidth, true);
  }

  $('#welcome-modal').on('hidden.bs.modal', function (e) {
    setCookie('seen-modal', true);
  })

  if(!getCookie('seen-modal') && !Modernizr.touch) {
    $('#welcome-modal').modal('show');
  }

  if(!Modernizr.touch){
    $(window).on('resize', function(){
      var $sgViewport = $('#sg-viewport');
      var h = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
      $($sgViewport).height(h-55);
      sizeiframe(document.body.clientWidth);
    });
  }
});

function sizeiframe(size) {
  if( Modernizr.touch ) {
    return;
  }

  $('#menu-content').slimScroll({
       destroy: 'true'
   });

  var $sgViewport = $('#sg-viewport');
  var h = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
  $($sgViewport).height(h-55);
  $('#sg-gen-container,#sg-viewport').addClass("vp-animate");
  $sgViewport.width(size);
};

function setCookie(key, value) {
  var expires = new Date();
  expires.setTime(expires.getTime() + (1 * 24 * 60 * 60 * 1000));
  document.cookie = key + '=' + value + ';expires=' + expires.toUTCString();
}

function getCookie(key) {
  var keyValue = document.cookie.match('(^|;) ?' + key + '=([^;]*)(;|$)');
  return keyValue ? keyValue[2] : null;
}