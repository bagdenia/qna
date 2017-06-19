class VotesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :load_vote, only: :destroy
  before_action :load_votable, only: :create

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
    @votable = @vote.votable
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
      @votable = votable_name.classify.constantize.find(params[votable_id])
    end

    def votable_name
      params[:votable]
    end

    def votable_id
      votable_name.singularize+"_id"
    end
end
