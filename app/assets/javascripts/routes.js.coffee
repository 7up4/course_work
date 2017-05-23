# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
set_time_picker= -> $('.timepicker').datetimepicker({locale: 'ru', format: 'HH:mm', defaultDate: ""})
set_checkbox= -> $('.switch:checkbox').bootstrapSwitch()
delete_nil_from_selector= ->  $(".select_existing_station:visible").children("option[value='']").remove()
remove_station= ->
  $(".remove_station").click (e) ->
    e.preventDefault()
    my_nested_field = $(this).closest('.nested-fields')
    to_remove = my_nested_field.find('.select_existing_station').val()
    $('.nested-fields').not(my_nested_field).find(".select_existing_station option[value="+to_remove+"]").remove()
    my_nested_field.find('.station_destroy').val(1)
    my_nested_field.find('.remove_fields.existing').click()
    $('.nested-fields').not(my_nested_field).find('.hidden_station_id').each (index, elem) ->
      if ($(elem).val() == to_remove)
        $(elem).val('')
        
existing_station_ajax= ->
  $('#route_stations .select_existing_station').on 'change', (evt) ->
    $.ajax
      url: '/fill_nested_station',
      type: 'POST',
      dataType: 'script',
      data: {
        station_to_fill: [$(this).val(), $(this).attr('name')]
      }
      
onreload= ->
  hrs = $('.nested-fields:hidden').has('.station_destroy[value=1]').find('.hidden_station_id')
  select_fields = $(".select_existing_station:visible")
  $(hrs).each (k,e) ->
    if $(e).val()
      $(select_fields).children("option[value="+$(e).val()+"]").remove()  
                
ready= ->
  $('#route_stations').on 'cocoon:after-insert', ->
    set_time_picker()
    existing_station_ajax()
    set_checkbox()
    remove_station()
    onreload()
  delete_nil_from_selector()
  set_time_picker()
  existing_station_ajax()
  set_checkbox()
  remove_station()

$(document).ready ready
$(document).on 'page:load', ready
$(window).load onreload