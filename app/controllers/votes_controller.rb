class VotesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :load_vote, only: :destroy
  before_action :load_votable

  respond_to :json

  def create
    if @votable.user_id != current_user.id
      @vote = @votable.votes.build(vote_params.merge(user: current_user))
      if @vote.save
        @votable.reload
        render :vote
      else
        render json: @vote.errors.full_messages, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @votable = @vote.votable_type.constantize.find(@vote.votable_id)
    if current_user.id  == @vote.user_id
      if @vote.destroy
        @votable.reload
        render :vote
      else
        render json: @vote.errors.full_messages, status: :unprocessable_entity
      end
     end
  end

  private

    def vote_params
      params.require(:vote).permit(:id, :elect);
    end

    def load_vote
      @vote = Vote.find(params[:id])
    end
    def load_votable
      if params[:question_id]
        @votable = Question.find(params[:question_id])
      elsif params[:answer_id]
        @votable = Answer.find(params[:answer_id])
      end
    end
end
