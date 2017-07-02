# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
editOn = ->
  $('.votes').bind 'ajax:success', (e, data, status, xhr) ->
    item = $.parseJSON(xhr.responseText)
    element = "div#" + item.class
    $("#{element}-#{item.id} .votes").html(JST["templates/voting"]({object: item}))
    $(".errors").html("")
   .bind 'ajax:error', (e, xhr, status, error) ->
     errors = $.parseJSON(xhr.responseText)
     $.each errors, (index, value) ->
       $(".errors").append(value + '<br>')

ready = ->
  editOn()

$(document).on('turbolinks:load', ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)


