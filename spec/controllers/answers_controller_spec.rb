require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) {create(:question)}
  describe 'GET #index' do
    let(:answers) {create_list(:answer,2, question: question)}
    before {get :index, params: {question_id: question.id} }
    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
