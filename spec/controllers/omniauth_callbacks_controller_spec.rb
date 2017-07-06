require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }
  describe 'FB' do
   before do
     request.env["devise.mapping"] = Devise.mappings[:user]
     request.env["omniauth.auth"] = mock_auth_hash(:facebook)
   end
   context 'with a new facebook user' do
     before do
       get :facebook
     end
     it 'redeirects to new_user_path' do
       expect(response).to redirect_to(new_user_session_path)
     end
     it 'doesnt signin user' do
       expect(controller.current_user).to eq nil
     end
   end

   context 'with existing facebook user' do
     before do
      auth = mock_auth_hash(:facebook)
      user.update!(email: auth.info.email)
      user.update!(confirmed_at: DateTime.now)
      authorization = create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
      get :facebook
     end
     it 'redeirects to rootpath' do
        expect(response).to redirect_to(root_path)
     end
     it 'signin user' do
       expect(controller.current_user).to eq user
     end
   end
  end

  describe 'VK' do
   before do
     request.env["devise.mapping"] = Devise.mappings[:user]
     request.env["omniauth.auth"] = mock_auth_hash(:vkontakte)
   end
   context 'with a new VK user' do
     before do
       get :vkontakte
     end
     it 'redeirects to new_user_path' do
       expect(response).to render_template 'omniauth_callbacks/enter_email'
     end
     it 'doesnt signin user' do
       expect(controller.current_user).to eq nil
     end
   end

   context 'with existing VK user' do
     before do
      auth = mock_auth_hash(:vkontakte)
      user.update!(confirmed_at: DateTime.now)
      authorization = create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
      get :vkontakte
     end
     it 'redeirects to rootpath' do
        expect(response).to redirect_to(root_path)
     end
     it 'signin user' do
       expect(controller.current_user).to eq user
     end
   end
  end
end
