# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
editOn = ->
  $(document).on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

ready = ->
  editOn()

$(document).on('turbolinks:load', ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)

answerOn = ->
    App.answers = App.cable.subscriptions.create('AnswersChannel', {
      connected: ->
        setTimeout =>
          @installedPageChangeCallback = false
          @followCurrentAnswer()
          @installPageChangeCallback()
        , 1000

      followCurrentAnswer: ->
        console.log('Connected Gon.question_id: ', gon.question_id)
        console.log('Connected User id: ', gon.current_user_id)
        return unless gon.question_id
        @perform 'follow', id: gon.question_id

      disconnected: ->

      received: (data) ->
        answer = $.parseJSON(data)
        # console.log('Received gon  User id: ', gon.current_user_id)
        # console.log('Received answer User id: ', answer.user_id)
        # console.log('Received Answer id: ', answer.id)
        # console.log('Received Question id: ', answer.question_id)
        # console.log('Received Gon question id: ', gon.question_id)
        return if gon.current_user_id == answer.user_id
        $("#table-answers").append(JST["templates/answer"]({object: answer}))

      installPageChangeCallback: ->
        unless @installedPageChangeCallback
          @installedPageChangeCallback = true
          $(document).on 'turbolinks:load', -> App.answers.followCurrentAnswer()
    })

$(document).on('turbolinks:load', answerOn)
$(document).on('page:load', answerOn)
$(document).on('page:update', answerOn)
