class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :load_comment, only: [:show]
  before_action :load_commentable, only: :create

  # respond_to :json

  def create
    @comment= Comment.create(comment_params.merge(user_id: current_user.id))
    @comment= @commentable.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      # @commentable.reload
    else
      # render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end


  private

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
