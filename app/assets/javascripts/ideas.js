//Tells to make the call using a javascript request
jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

//Reusable function to leverage the action on the form to call a specific controller
jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

//Forward button for the idea creation tracker
$(document).ready(function() {
  $(".forwardbtnform").submitWithAjax();
});

//Back button for the idea creation tracker
$(document).ready(function() {
  $(".backbtnform").submitWithAjax();
});