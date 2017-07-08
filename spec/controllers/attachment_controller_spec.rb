require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) {create(:question, user: user)}
  let!(:attachment) { create(:attachment, attachmentable: question) }


  describe 'DELETE #destroy' do

    context 'User can delete his attachment' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[user]
        sign_in user
      end
      it 'delete attachment' do
        expect { delete :destroy, params: { id: attachment, format: :js} }.to change(question.attachments, :count).by(-1)
      end
      it 'render template destroy' do
        delete :destroy, params: { id: attachment }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User cant delete other user attachment' do
      before do
        other_user = create(:user)
        @request.env['devise.mapping'] = Devise.mappings[other_user]
        sign_in other_user
      end
      it 'dsnt delete attachment' do
        expect { delete :destroy, params: { id: attachment},format: :js }.to_not change(question.attachments, :count)
      end

      it 'render template destroy' do
        delete :destroy, params: { id: attachment}, format: :js
        expect(response).to redirect_to root_url
      end
    end
  end



end
