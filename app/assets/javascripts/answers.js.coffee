# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

editOn = ->
  $(document).on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      return unless gon.question_id
      @perform 'follow', id: gon.question_id
    ,
    received: (data) ->
      answer = $.parseJSON(data)
      return if gon.current_user_id == answer.user_id
      $("#table-answers").append(JST["templates/answer"]({object: answer}))
  })
ready = ->
  editOn()

$(document).on('turbolinks:load', ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
