require 'rails_helper'
RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user)}
  let(:vote) {build(:vote, user: user, votable: question,
                    votable_type: 'Question', elect: true)}
  let!(:vote_to_destroy) {create(:vote, user: other_user, votable: question,
                    votable_type: 'Question', elect: true)}
  describe 'POST #create' do
    sign_in_user
      it 'saves new vote to db' do
        expect{ post :create, params: {vote: vote.attributes}, format: :json }.to change(question.votes, :count).by(1)
      end
      it 'render template vote' do
        post :create, params: {vote: vote.attributes}, format: :json
        expect(response).to render_template :vote
      end
      it 'changes question rating' do
        expect{ post :create, params: {vote: vote.attributes}, format: :json }.to change {question.reload.rating}.by(1)

      end
  end

  describe 'DELETE #destroy' do
    context "User can unvote" do
      before do
        @request.env['devise.mapping'] = Devise.mappings[other_user]
        sign_in other_user
      end
      it 'delete vote' do
        expect { delete :destroy, params: { id: vote_to_destroy.id, format: :json} }.to change(Vote, :count).by(-1)
      end
      it 'render template' do
        delete :destroy, params: { id: vote_to_destroy.id, format: :json}
        expect(response).to render_template :vote
      end
      it 'changes question rating' do
        expect{ delete :destroy, params: { id: vote_to_destroy.id,
                                           format: :json}}.to change {question.reload.rating}.by(-1)
      end
    end

    context "Another user cant unvote" do
      before do
        @request.env['devise.mapping'] = Devise.mappings[another_user]
        sign_in another_user
      end
      it 'delete vote' do
        expect { delete :destroy, params: { id: vote_to_destroy.id, format: :json} }.to_not change(Vote, :count)
      end
      it 'changes question rating' do
        expect{ delete :destroy, params: { id: vote_to_destroy.id,
                                           format: :json}}.to_not change {question.reload.rating}
      end
    end
  end
end
