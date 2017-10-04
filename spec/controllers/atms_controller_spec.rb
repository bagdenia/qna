require 'rails_helper'

RSpec.describe AtmsController, type: :controller do
  describe 'POST #create' do
      it 'saves new atm to db' do
        expect { post :create, params: { atm: attributes_for(:atm) }, format: :js}.to change{ Atm.count }.by(1)
      end

      it 'redirect to atms_path' do
        post :create, params: { atm: attributes_for(:atm) }, format: :js
        expect(response).to render_template :create
      end
  end

  describe 'GET #index' do
    let(:atms)  { create_list(:atm, 10) }
    before {get :index}
    it 'returns an array of all atms' do
      expect(assigns(:atms)).to match_array(atms)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #closest' do
    let(:atms)  { create_list(:atm, 10) }
    before {get :closest, params: { lat: atms.first.lat, lng: atms.first.lng } }
    it 'returns an array of 5 atms' do
      expect(assigns(:atms).count).to eq 5
      expect(assigns(:atms).first[0]).to eq atms.first
    end
    it 'renders closest view' do
      expect(response).to render_template :closest
    end
  end


end
