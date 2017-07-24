require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user){ create(:user) }
  let(:other_user){ create(:user) }
  let(:another_user){ create(:user) }
  let!(:question){ create(:question, user: user) }
  let(:subscription){ create(:subscription, question: question, user: other_user)}
  describe "POST #create" do
    context 'signed_in user' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[other_user]
        sign_in other_user
      end
      it 'creates new subscription' do
        expect{ post :create, params: {subscription: {question_id: question.id}, user: other_user,
                                       format: :js}}.to change(Subscription, :count).by(1)
      end
      it 'renders act.js' do
        post :create, params: {subscription: {question_id: question.id}, user: user,
                                             format: :js}
        expect(response).to render_template :act
      end
    end
    context 'not signed_in user' do
      it 'cant create new subscription' do
        expect{ post :create, params: {subscription: {question_id: question.id}, user: other_user,
                                       format: :js}}.to_not change(Subscription, :count)
      end
      it 'responds with status 401' do
        post :create, params: {subscription: {question_id: question.id}, user: user,
                                             format: :js}
        expect(response.status).to eq(401)
      end
    end
  end

  describe "DELETE #destroy" do
    context 'signed_in user can unsubscribe' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[other_user]
        sign_in other_user
        subscription
      end
      it 'delete subscription' do
        expect { delete :destroy, params: { id: subscription.id, format: :js} }.to change(Subscription, :count).by(-1)
      end
      it 'render act' do
        delete :destroy, params: { id: subscription.id, format: :js}
        expect(response).to render_template :act
      end
    end

    context 'signed_in user cant unsubscribe for other_user' do #не должен по acbility, не пойму где накосячила
      before do
        @request.env['devise.mapping'] = Devise.mappings[another_user]
        sign_in another_user
        subscription
      end
      it 'cant delete subscription' do
        expect { delete :destroy, params: { id: subscription.id, format: :js} }.to_not change(Subscription, :count)
      end
      it 'doesnt render act' do
        delete :destroy, params: { id: subscription.id, format: :js}
        expect(response.status).to eq(201)
      end
    end

    context 'not signed_in user cant unsubscribe' do
      before do
        subscription
      end
      it 'doesnt delete subscription' do
        expect { delete :destroy, params: { id: subscription.id, format: :js} }.to_not change(Subscription, :count)
      end
      it 'respond with status 401' do
        delete :destroy, params: { id: subscription.id, format: :js}
        expect(response.status).to eq(401)
      end
    end
  end



end

