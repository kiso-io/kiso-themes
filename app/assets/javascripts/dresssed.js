//= require_tree ./dresssed

$(document).ready(function(){
  $('[data-toggle="popover"]').popover({
    container: 'body'
  });

  $('[data-toggle="tooltip"]').tooltip({
    container: 'body'
  });

  $('.nav-side-menu').metisMenu();
});
