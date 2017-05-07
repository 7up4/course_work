# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load', ->
  $('#route_stations').on('cocoon:after-insert', -> $('.timepicker').datetimepicker({locale: 'ru', format: 'HH:mm', defaultDate: ""}))
  $('.timepicker').datetimepicker({locale: 'ru', format: 'HH:mm', defaultDate: ""})
)
