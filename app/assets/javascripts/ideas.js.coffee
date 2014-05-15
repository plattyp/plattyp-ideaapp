# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


#This script is used to go directly to the table using the achor for stacked navigation pills

$(document).ready ->
    if location.hash != ''
        $('a[href="'+location.hash+'"]').tab('show')

    $('a[data-toggle="tab"]').on 'shown', (e) ->
        location.hash = $(e.target).attr('href').substr(1)

