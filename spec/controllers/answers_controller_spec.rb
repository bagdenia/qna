require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) {create(:question)}
  let(:answer) {create(:answer, question: question)}
  #let(:answer) {create(:question_with_answer)}

  describe 'GET #index' do
    let(:answers) {create_list(:answer, 2, question: question)}
    before {get :index, params: {question_id: question} }
    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end
    it 'populates an array of question particular answers' do
      expect(assigns(:answers)).to eq(question.answers)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

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
    context 'with valid attrs' do
      it 'saves new answer to db' do
        expect { post :create, params:{ question_id: question,
                 answer: attributes_for(:answer)} }.to change(question.answers, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:answer)}
        expect(response).to redirect_to question_answer_path(question, assigns(:answer))
      end
    end

    context 'with invalid attrs' do
      it 'does not save new anwser to db' do
        expect { post :create, params:{ question_id: question,
                 answer: attributes_for(:invalid_answer)} }.to_not change(question.answers, :count)
      end
      it 're-renders new view' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:invalid_answer)}
        expect(response).to render_template :new
      end
    end
  end

end



