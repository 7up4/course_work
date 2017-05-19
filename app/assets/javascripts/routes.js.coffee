# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
set_time_picker= -> $('.timepicker').datetimepicker({locale: 'ru', format: 'HH:mm', defaultDate: ""})
set_checkbox= -> $('.switch:checkbox').bootstrapSwitch();
remove_station= ->
  $(".remove_station").click (e) ->
    e.preventDefault()
    my_nested_fields = $(this).closest('.nested-fields')
    removed = my_nested_fields.find('.select_existing_station').val()
    $('.nested-fields').not(my_nested_fields).find(".select_existing_station option[value='"+removed+"']").remove();
    my_nested_fields.find('.station_destroy').val(1)
    my_nested_fields.find('.hidden_remove_station').val(removed)
    my_nested_fields.find('.remove_fields.existing').click()
    $('.nested-fields').not(my_nested_fields).find('.hidden_station_id').each (index, elem) ->
      if ($(elem).val() == removed)
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
  hrs = $('.hidden_remove_station')
  $(hrs).each (k,e) ->
    if $(e).val()
      select_fields = $(".select_existing_station:visible")
      $(select_fields).children("option[value="+$(e).val()+"]").remove()  
                
ready= ->
  $('#route_stations').on 'cocoon:after-insert', ->
    set_time_picker()
    existing_station_ajax()
    set_checkbox()
    remove_station()
    onreload()
  set_time_picker()
  existing_station_ajax()
  set_checkbox()
  remove_station()

$(document).ready ready
$(document).on 'page:load', ready
$(window).load onreload