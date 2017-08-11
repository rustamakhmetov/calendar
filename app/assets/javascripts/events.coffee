# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-event-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    event_id = $(this).data('eventId')
    $('form#edit_event_' + event_id).show();

  $('.share-event-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    event_id = $(this).data('eventId')
    $('form#share_event_' + event_id).show();

$(document).ready(ready);
$(document).on('turbolinks:load', ready);