require 'rails_helper'

RSpec.describe ThinkingSphinxController, type: :controller do

  describe 'GET #search' do
    it 'get search everywhere with empty condition' do
      expect(ThinkingSphinx).to receive(:search).with('ask')
      get :search, params: {search_string: 'ask', condition: ''}
    end

    it 'get search everywhere with condition everyqhere' do
      expect(ThinkingSphinx).to receive(:search).with('ask')
      get :search, params: {search_string: 'ask', condition: 'Everywhere'}
    end


    %w(Questions Answers Comments Users).each do |attr|
      it "gets condition: #{attr}" do
        expect(attr.singularize.classify.constantize).to receive(:search).with('ask')
        get :search, params: {search_string: 'ask', condition: attr}
      end
    end

    %w(Everywhere Questions Answers Comments Users).each do |attr|
      it 'redirect to search' do
        get :search, params: {search_string: 'ask', condition: attr}
        expect(response).to render_template :search
      end
    end
  end

end
