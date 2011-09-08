// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

$(document).ready(function() {
  $("#comment_form").submitWithAjax();
  
  $('#selections').sortable({
    axis: 'y',
    dropOnEmpty: false,
    handle: '.handle',
    cursor: 'crosshair',
    items: 'li',
    opacity: 0.4,
    scroll: true,
    update: function(){
    $.ajax({
      type: 'post',
      data: $('#selections').sortable('serialize'),
      dataType: 'script',
      complete: function(request){
        $('#selections').effect('highlight');
      },
      url: '/selections/sort'})
    }
  });
})

