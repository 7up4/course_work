# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# nested_stuff= (item) ->
#   check_to_hide_or_show_add_link= ->
#     if (item.find('.nested-fields:visible').length == 1)
#       item.find('.links a').addClass('hidden')
#       # item.closest('.row').find('#tariff_zone_select').addClass('hidden')
#       item.find(":input").prop('disabled', false)
#     else
#       item.find('.links a').removeClass('hidden')
#       # item.closest('.row').find('#tariff_zone_select').removeClass('hidden')
#       item.find(":input").prop('disabled', true)
# 
#   item.on 'cocoon:after-insert', -> check_to_hide_or_show_add_link()
# 
#   item.on 'cocoon:after-remove', ->
#     item.find("input[type='hidden']").remove()
#     check_to_hide_or_show_add_link()
# 
#   check_to_hide_or_show_add_link()
# 
# $(document).on 'turbolinks:load', ->
#   tariff_zone = $(document).find("#tariff_zone.nested-fields")
#   if ($(document).find("#route_stations").length)
#     if (tariff_zone.length)
#       tariff_zone.each -> nested_stuff($(this).parent())
#     else
#       $("#route_stations").on 'cocoon:after-insert', (e, insertedItem) ->
#         if insertedItem.is('.nested-fields#tariff_zone')
#           nested_stuff(insertedItem.parent())
#   else
#     if (tariff_zone.length)
#       nested_stuff(tariff_zone.parent())
#     else
#       $('form').on 'cocoon:after-insert', (e, insertedItem) ->
#         nested_stuff(insertedItem.parent())

existing_tariff_zone_ajax= ->
  $('#tariff_zone_select #select_existing_tariff_zone').on 'change', (evt) ->
    $.ajax
      url: '/fill_nested_tariff_zone',
      type: 'GET',
      dataType: 'script',
      data: {
        tariff_zone_to_fill: [$(this).val(), $(this).attr('name')]
      },
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic tariff_zone select OK!")
        
$(document).on 'turbolinks:load', ->
  $('#route_stations').on 'cocoon:after-insert', ->
    existing_tariff_zone_ajax()
  existing_tariff_zone_ajax()
