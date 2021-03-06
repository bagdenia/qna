class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :load_comment, only: [:show, :destroy]
  before_action :load_commentable, only: :create
  after_action :publish_comment, only: :create

  respond_to :js
  authorize_resource

  def create
    respond_with(@comment= @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  def destroy
    respond_with(@comment.destroy)
  end


  private
    def publish_comment
      return if @comment.errors.any?
      if params['question_id'].present?
        question_id = params['question_id']
      else
        question_id = @comment.commentable.question_id
      end
      ActionCable.server.broadcast "questions/#{question_id}/comments",
        ApplicationController.render(
          partial: 'comments/comment_channel',
          locals: {comment: @comment}
        )
    end

    def comment_params
      params.require(:comment).permit(:id, :body);
    end

    def load_comment
      @comment = Comment.find(params[:id])
    end

    def load_commentable
      @commentable = commentable_name.classify.constantize.find(params[commentable_id])
    end

    def commentable_name
      params[:commentable]
    end

    def commentable_id
      commentable_name.singularize+"_id"
    end
end
