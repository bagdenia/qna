require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) {create(:question, user: user)}
  let(:answer) {create(:answer, question: question, user: user)}


  describe 'GET #show' do
    before {get :show, params: {question_id: question,
                                id: answer} }
    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end
    it 'assigns the requested answer question to correspond @question' do
      expect(assigns(:answer).question).to eq question
    end
    it 'renders show view' do
      expect(response).to render_template :show
    end

  end

  describe 'GET #new' do
    sign_in_user
    before {get :new, params: {question_id: question}}
    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'check new answer to correspond question' do
      expect(assigns(:question).answers.first).to be_a_new(Answer)
    end
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end


  describe 'POST #create' do
    sign_in_user
    context 'with valid attrs' do
      it 'saves new answer to db' do
        expect { post :create, params:{ question_id: question,
                                        user_id: user,
         answer: attributes_for(:answer), format: :js} }.to change(question.answers, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, params: { question_id: question,
                                user_id: user,
                                answer: attributes_for(:answer), format: :js}
        expect(response).to render_template :create
      end
    end

    context 'with invalid attrs' do
      it 'does not save new anwser to db' do
        expect { post :create, params:{ question_id: question,
                 answer: attributes_for(:invalid_answer), format: :js} }.to_not change(question.answers, :count)
      end
      it 're-renders new view' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:invalid_answer), format: :js}
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    before {user}
    before {answer}

    context 'User can delete his answer' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[user]
        sign_in user
      end
      it 'delete answer' do
        expect { delete :destroy, params: { id: answer} }.to change(Answer, :count).by(-1)
      end
      it 'redirect to question' do
        delete :destroy, params: { id: answer}
        expect(response).to redirect_to question
      end
    end

    context 'User cant delete other user answer' do
      before do
        other_user = create(:user)
        @request.env['devise.mapping'] = Devise.mappings[other_user]
        sign_in other_user
      end
      it 'dsnt delete answer' do
        expect { delete :destroy, params: { id: answer} }.to_not change(Answer, :count)
      end
      it 'redirect to question' do
        delete :destroy, params: { id: answer}
        expect(response).to redirect_to question
      end
    end
  end


  describe 'PATCH #update' do
    before {user}
    before {answer}
    context 'User can edit his answer' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[user]
        sign_in user
      end
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer)}, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answers attributes' do
        patch :update, params: {id: answer, answer: {body: 'new body'}}, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer)}, format: :js
        expect(response).to render_template :update
      end
    end

    context 'User cant edit other user answer' do
      before do
        other_user = create(:user)
        @request.env['devise.mapping'] = Devise.mappings[other_user]
        sign_in other_user
      end
      it 'doesnt change answers attributes' do
        patch :update, params: {id: answer, answer: {body: 'new body'}}, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
      it 'redirect to question' do
        patch :update, params: {id: answer, answer: {body: 'new body'}}, format: :js
        expect(response).to_not redirect_to question
      end

    end
  end


end



