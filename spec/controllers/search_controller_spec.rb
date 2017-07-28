require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe 'GET #search' do
    it 'get search everywhere with empty condition' do
      expect(Search).to receive(:search_result).with('ask', '')
      get :search, params: {search_string: 'ask', condition: ''}
    end

    it 'get search everywhere with condition everyqhere' do
      expect(Search).to receive(:search_result).with('ask', 'Everywhere')
      get :search, params: {search_string: 'ask', condition: 'Everywhere'}
    end


    %w(Questions Answers Comments Users).each do |attr|
      it "gets condition: #{attr}" do
        expect(Search).to receive(:search_result).with('ask', attr)
        # expect(attr.singularize.classify.constantize).to receive(:search).with('ask')
        get :search, params: {search_string: 'ask', condition: attr}
      end
    end

    %w(Everywhere Questions Answers Comments Users).each do |attr|
      it 'redirect to search' do
        get :search, params: {search_string: 'ask', condition: attr}
        expect(response).to render_template :search
      end
    end

    it "gets condition: noname" do
      expect(Search).to receive(:search_result).with('ask', 'Noname')
      # expect(ThinkingSphinx).to receive(:search).with('ask')
      get :search, params: {search_string: 'ask', condition: 'Noname'}
    end
  end

end
