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
