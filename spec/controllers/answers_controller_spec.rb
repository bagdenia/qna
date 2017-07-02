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


  describe 'POST #create' do
    sign_in_user
    context 'with valid attrs' do
      it 'saves new answer to db' do
        expect { post :create, params:{ question_id: question,
                                        user_id: user,
         answer: attributes_for(:answer), format: :js} }.to change(question.answers, :count).by(1)
      end
      it 'render template create' do
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
        expect { delete :destroy, params: { id: answer, format: :js} }.to change(Answer, :count).by(-1)
      end
      it 'render template destroy' do
        delete :destroy, params: { id: answer}, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User cant delete other user answer' do
      before do
        other_user = create(:user)
        @request.env['devise.mapping'] = Devise.mappings[other_user]
        sign_in other_user
      end
      it 'dsnt delete answer' do
        expect { delete :destroy, params: { id: answer},format: :js }.to_not change(Answer, :count)
      end

      it 'render template destroy' do
        delete :destroy, params: { id: answer}, format: :js
        expect(response).to render_template :destroy
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

  describe 'patch #set_best' do
    before {user}
    before {question}
    before {answer}
    context 'Questions author try to set_best' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[user]
        sign_in user
        patch :set_best, params: {id: answer}, format: :js
      end
      it 'set best to true' do
        answer.reload
        expect(answer.best).to eq true
      end
      it 'render set_best template' do
        expect(response).to render_template :set_best
      end
    end

    context 'User try to set_best answer for other author question' do
      before do
        other_user = create(:user)
        @request.env['devise.mapping'] = Devise.mappings[user]
        sign_in other_user
      end

      it 'cant set best' do
        expect { patch :set_best, params: { id: answer}, format: :js }.to_not change(answer, :best)
      end
      it 'render set_best template' do
        patch :set_best, params: {id: answer}, format: :js
        expect(response).to render_template :set_best
      end
    end

  end


end



