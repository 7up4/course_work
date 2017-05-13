# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
set_time_picker= -> $('.timepicker').datetimepicker({locale: 'ru', format: 'HH:mm', defaultDate: ""})
set_checkbox= -> $('.switch:checkbox').bootstrapSwitch();
remove_station= ->
  $(".remove_station").click (e) ->
    e.preventDefault()
    $(this).closest('.nested-fields').find('.hidden_remove_station').val("1")
    $(this).closest('.nested-fields').find('.remove_fields.existing').click()
existing_station_ajax= ->
  $('#route_stations #select_existing_station').on 'change', (evt) ->
    $.ajax
      url: '/fill_nested_station',
      type: 'POST',
      dataType: 'script',
      data: {
        station_to_fill: [$(this).val(), $(this).attr('name')]
      },
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic station select OK!")
        
ready= ->
  $('#route_stations').on 'cocoon:after-insert', ->
    set_time_picker()
    existing_station_ajax()
    set_checkbox()
    remove_station()
  set_time_picker()
  existing_station_ajax()
  set_checkbox()
  remove_station()

$(document).ready ready
$(document).on 'page:load', ready