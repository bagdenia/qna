# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
editOn = ->
  $('.votes').bind 'ajax:success', (e, data, status, xhr) ->
    item = $.parseJSON(xhr.responseText)
    $('.answr').append(JST["templates/test"]({world: item.id}))


ready = ->
  editOn()

$(document).on('turbolinks:load', ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)


# # $('.answr').bind 'ajax:success', (e, data, status, xhr) ->
# #     votable = $.parseJSON(xhr.responseText)
# #     class_to_repl =
# #     $('.answers').append('<p>' + answer.body + '</p>')
# #   .bind 'ajax:error', (e, xhr, status, error) ->
# #     errors = $.parseJSON(xhr.responseText)
# #     $.each errors, (index, value) ->
# #       $('.answer-errors').append(value)
