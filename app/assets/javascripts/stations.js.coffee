# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
remove_tariff_zone= ->
  onreload = $('.hidden_remove_tariff_zone').val()
  if onreload
    $("#select_existing_tariff_zone option[value='"+onreload+"']").remove()
  $('.remove_tariff_zone').click ->
    to_remove = $('.hidden_tariff_zone_id').val()
    $("#select_existing_tariff_zone option[value='"+to_remove+"']").remove()
    $('.hidden_tariff_zone_id').val('')
    $('.tariff_zone_name_field').val('')
    $('.hidden_remove_tariff_zone').val(to_remove)
    $(this).remove()

existing_tariff_zone_ajax= ->
  $('#tariff_zone_select #select_existing_tariff_zone').on 'change', ->
    $.ajax
      url: '/fill_nested_tariff_zone',
      type: 'POST',
      dataType: 'script',
      data: {
        tariff_zone_to_fill: [$(this).val(), $(this).attr('name')]
      }

ready= ->        
  $('#route_stations').on 'cocoon:after-insert', ->
    existing_tariff_zone_ajax()
  existing_tariff_zone_ajax()
  remove_tariff_zone()
  
$(document).ready ready
$(document).on 'page:load', ready
