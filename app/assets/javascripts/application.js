// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

// Loads all Bootstrap javascripts
//= require bootstrap
//= require bootstrap/modal
//= require twitter/typeahead
//= require twitter/typeahead.min
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.es.js
//= require bootstrap3-editable/bootstrap-editable
//= require cocoon

jQuery(function() {
  return $.ajax({
    url: 'https://apis.google.com/js/client:plus.js?onload=gpAsyncInit',
    dataType: 'script',
    cache: true
  });
});

window.gpAsyncInit = function() {
  $('.googleplus-login').click(function(e) {
    e.preventDefault();
    gapi.auth.authorize({
      immediate: true,
      response_type: 'code',
      cookie_policy: 'single_host_origin',
      client_id: '47749075420-klc94acuasin42l8d0ctqc2kabe4ipce.apps.googleusercontent.com',
      scope: 'email profile'
    }, function(response) {
      if (response && !response.error) {
        // google authentication succeed, now post data to server and handle data securely
        jQuery.ajax({type: 'POST', url: "/auth/google_oauth2/callback", dataType: 'json', data: response,
          success: function(json) {
            // response from server
          }
        });
      } else {
        // google authentication failed
      }
    });
  });
};