class VotesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :load_vote, only: :destroy

  def create
    @votable = Class.const_get(vote_params[:votable_type]).find(vote_params[:votable_id])
    @vote = @votable.votes.build(vote_params.merge(user: current_user))
    respond_to do |format|
      if @vote.save
        @votable.reload
        format.html { redirect_to(request.env['HTTP_REFERER']) }
        format.json { render :vote}
        # format.json { render json: @votable }
      else

      end
    end
  end

  def destroy
    @votable = Class.const_get(@vote.votable_type).find(@vote.votable_id)
    if current_user.id  == @vote.user_id
      respond_to do |format|
        if @vote.destroy
          @votable.reload
          format.html { redirect_to(request.env['HTTP_REFERER']) }
          format.json { render :vote}
          # format.json { render json: @votable }
        else
        end
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
