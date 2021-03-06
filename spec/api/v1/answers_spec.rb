require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) {answers.first}

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token }}

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2)
      end

      %w(id body).each do |attr|
        it "response contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
    def do_request(options = {})
      question = create(:question)
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question)}
      let(:answer) { create(:answer, question: question)}
      let!(:attachment) { create(:attachment, attachmentable: answer) }
      let!(:comment) { create(:comment, commentable: answer, user: question.user) }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token }}

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end
      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        it 'has attachment url attr' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/url")
        end
      end
      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("comments")
        end
        %w(id body).each do |attr|
          it "comment contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end
    end
    def do_request(options = {})
      answer = create(:answer)
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question) }
      before{ post "/api/v1/questions/#{question.id}/answers", params: { action: :create, access_token: access_token.token,
                                                                         format: :json, answer: attributes_for(:answer)}}
      it 'returns success' do
        expect(response).to be_success
      end

      it 'creates answer' do
        expect{ post "/api/v1/questions/#{question.id}/answers", params: { action: :create, access_token: access_token.token,
                                             format: :json, answer: attributes_for(:answer)}}.to change(Answer, :count).by(1)
      end


    end
    def do_request(options = {})
      question = create(:question)
      post "/api/v1/questions/#{question.id}/answers", params: { action: :create, format: :json, answer: attributes_for(:answer)}.merge(options)
    end

  end
end
