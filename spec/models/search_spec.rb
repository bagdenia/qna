require 'rails_helper'

RSpec.describe Search do

  describe 'method search_result' do
    %w(Noname Everywhere '').each do |attr|
      it "gets condition #{attr}" do
        expect(ThinkingSphinx).to receive(:search).with('ask')
        Search.search_result('ask', attr)
      end
    end



    %w(Questions Answers Comments Users).each do |attr|
      it "gets condition: #{attr}" do
        expect(attr.singularize.classify.constantize).to receive(:search).with('ask')
        Search.search_result('ask', attr)
      end
    end
  end
end
