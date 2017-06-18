class VotesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :load_vote, only: :destroy

  respond_to :json

  def create
    @votable = vote_params[:votable_type].constantize.find(vote_params[:votable_id])
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
      params.require(:vote).permit(:id, :elect, :votable_id, :votable_type);
    end

    def load_vote
      @vote = Vote.find(params[:id])
    end
end
