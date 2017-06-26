  # App.cable.subscriptions.create('AnswersChannel', {
  #   connected: ->
  #     console.log('Connected Gon.question_id: ', gon.question_id)
  #     console.log('Connected Gon.question_user_id:', gon.question_user_id)
  #     console.log('Connected User id: ', gon.current_user_id)
  #     $("#table-answers").append("div Connected #{gon.question_id}")
  #     return unless gon.question_id
  #     @perform 'follow', id: gon.question_id
  #
  #   disconnected: ->
  #
  #   received: (data) ->
  #     answer = $.parseJSON(data)
  #     console.log('Received gon  User id: ', gon.current_user_id)
  #     console.log('Received answer User id: ', answer.user_id)
  #     console.log('Received Answer id: ', answer.id)
  #     console.log('Received Question id: ', answer.question_id)
  #     console.log('Received Gon question id: ', gon.question_id)
  #     $("#table-answers").append("div Received #{gon.question_id}")
  #     return if gon.current_user_id == answer.user_id
  #     $("#table-answers").append(JST["templates/answer"]({object: answer}))
  # })
