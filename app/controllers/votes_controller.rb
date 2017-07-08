class VotesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :load_vote, only: :destroy
  before_action :load_votable_and_vote, only: :create
  authorize_resource
  respond_to :json

  def create
    if @vote.save
      @votable.reload
      render :vote  #тут не меняла на respond_with, потому как не сам инстанс в json возвращаем
    else
      render json: @vote.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    if @vote.destroy
      @votable.reload
      render :vote
    else
      render json: @vote.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

    def vote_params
      params.require(:vote).permit(:id, :elect);
    end

    def load_vote
      @vote = Vote.find(params[:id])
      @votable = @vote.votable
    end

    def load_votable_and_vote
      @votable = votable_name.classify.constantize.find(params[votable_id])
      @vote = @votable.votes.build(vote_params.merge(user: current_user))
    end

    def votable_name
      params[:votable]
    end

    def votable_id
      votable_name.singularize+"_id"
    end
end
