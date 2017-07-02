require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, title: 'My title', body: 'My body', user: user) }
  describe 'GET #index' do
    let(:questions)  { create_list(:question,2,user: user) }
    before {get :index}
    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before {get :show, params: { user_id: user, id: question}}
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'assigns the requested question to correspond @user' do
      expect(assigns(:question).user).to eq  user
    end
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before {get :new}
    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before {get :edit, params: { id: question}}

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
      it 'redirects to show view' do
         post :create, params: { question: attributes_for(:question) }
         expect(response).to redirect_to assigns(:question)
      end
    end
    context 'with invalid attributes' do
      it 'does not save the new question in the database' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end
      it 'it re-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    before {question}
    before {user}

    context 'User can delete his question' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in user
      end
      it 'delete question' do
        expect { delete :destroy, params: { id: question} }.to change(Question, :count).by(-1)
      end
      it 'redirect to index view' do
        delete :destroy, params: { id: question}
        expect(response).to redirect_to questions_path
      end
    end

    context 'User cant delete other user question' do
      before do
        other_user = create(:user)
        @request.env['devise.mapping'] = Devise.mappings[other_user]
        sign_in other_user
      end
      it 'delete question' do
        expect { delete :destroy, params: { id: question} }.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    before {user}
    before {question}
    context 'User can edit his question' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[user]
        sign_in user
      end
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question)}, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: {id: question,
                                question: {body: 'new body'}}, format: :js
        question.reload
        expect(question.body).to eq 'new body'
      end

      it 'render update template' do
        patch :update, params: { id: question, question: attributes_for(:question)}, format: :js
        expect(response).to render_template :update
      end
    end

    context 'User cant edit other user question' do
      before do
        other_user = create(:user)
        @request.env['devise.mapping'] = Devise.mappings[other_user]
        sign_in other_user
      end
      it 'doesnt change question attributes' do
        patch :update, params: {id: question, question: {title: 'new titile', body: 'new body'}}, format: :js
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end
      it 'redirect to question' do
        patch :update, params: {id: question, question: {body: 'new body'}}, format: :js
        expect(response).to_not redirect_to question
      end
    end
  end
end
