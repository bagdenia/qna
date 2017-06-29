# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
show_comments = ->
  $(document).on 'click', '.show-comments-link', (e) ->
    e.preventDefault();
    link_text = $(this).text()
    if link_text = "Show comments"
      $(this).text("Hide comments")
      # question_id = $(this).data('questionId')
      comment_class = $(this).data('votableType') + $(this).data('votableId') + '_comments'
      $('#'+comment_class).show()
    $(this).removeClass('show-comments-link');
    $(this).addClass('hide-comments-link');

hide_comments = ->
  $(document).on 'click', '.hide-comments-link', (e) ->
    e.preventDefault();
    link_text = $(this).text()
    if link_text = "Hide comments"
      $(this).text("Show comments")
      comment_class = $(this).data('votableType') + $(this).data('votableId') + '_comments'
      $('#'+comment_class).hide()
      # question_id = $(this).data('questionId')
    $(this).removeClass('hide-comments-link');
    $(this).addClass('show-comments-link');

    # var = $("#<%= @comment.commentable_type.downcase + @comment.commentable_id.to_s %>_comments")
    # $('form#edit-question-' + question_id).show()

new_comment = ->
  $(document).on 'click', '.new-comment-link', (e) ->
    e.preventDefault();
    $(this).hide();
    comment_class = $(this).data('votableType') + $(this).data('votableId') + '-new-comment'
    $('form#' + comment_class).show()


ready = ->
  show_comments()
  hide_comments()
  new_comment()


$(document).on('turbolinks:load', ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)

commentOn = ->
    App.comments = App.cable.subscriptions.create('CommentsChannel', {
      connected: ->
        setTimeout =>
          @installedPageChangeCallback = false
          @followCurrentComment()
          @installPageChangeCallback()
        , 1000

      followCurrentComment: ->
        console.log('Connected Gon.question_id: ', gon.question_id)
        console.log('Connected User id: ', gon.current_user_id)
        return unless gon.question_id
        @perform 'follow', id: gon.question_id

      disconnected: ->

      received: (data) ->
        comment = $.parseJSON(data)
        # console.log('Received gon  User id: ', gon.current_user_id)
        # console.log('Received comment User id: ', comment.user_id)
        # console.log('Received comment id: ', comment.id)
        # # console.log('Received Question id: ', comment.question_id)
        # console.log('Received Gon question id: ', gon.question_id)
        commentable_type = comment.commentable_type
        commentable_id = comment.commentable_id
        # console.log('Received comment commentable_type: ', commentable_type + commentable_id)
        # console.log('Received comment commentable_id: ', commentable_id)
        # console.log('Received comment body: ', comment.body)
        return if gon.current_user_id == comment.user_id
        comment_class = comment.commentable_type+ comment.commentable_id + '_comments'
        $('#'+comment_class).append(JST["templates/comment"]({object: comment}))

      installPageChangeCallback: ->
        unless @installedPageChangeCallback
          @installedPageChangeCallback = true
          $(document).on 'turbolinks:load', -> App.comments.followCurrentComment()
    })

$(document).on('turbolinks:load', commentOn)
