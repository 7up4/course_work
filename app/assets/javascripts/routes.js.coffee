# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
set_time_picker= -> $('.timepicker').datetimepicker({locale: 'ru', format: 'HH:mm', defaultDate: ""})
existing_station_ajax= ->
  $('#route_stations #select_existing').on 'change', (evt) ->
    $.ajax 'fill_nested_form',
    type: 'GET'
    dataType: 'script'
    data: {
      station_to_fill: [$(this).val(), $(this).attr('name')]
    }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log("AJAX Error: #{textStatus}")
    success: (data, textStatus, jqXHR) ->
      console.log("Dynamic country select OK!")

$(document).on('turbolinks:load', ->
  $('#route_stations').on 'cocoon:after-insert', ->
    set_time_picker()
    existing_station_ajax()
  set_time_picker()
  existing_station_ajax()
)
