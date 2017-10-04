require 'rails_helper'

RSpec.describe Atm, type: :model do
  it {should validate_presence_of :address}
  it {should validate_presence_of :lat}
  it {should validate_presence_of :lng}

  it { should validate_numericality_of(:lat).is_greater_than_or_equal_to(-90).is_less_than_or_equal_to(90) }
  it { should validate_numericality_of(:lng).is_greater_than_or_equal_to(-180).is_less_than_or_equal_to(180) }


  describe 'get_closest' do
    let(:atms) { create_list(:atm, 10) }

    it 'returns 5 lmts closest to position' do
      test = atms.first
      closest_atms = Atm.get_closest(test.lat, test.lng)
      expect(closest_atms.count).to eq 5
      expect(closest_atms.first[0]).to eq atms.first
      (0..3).each {|i| expect(closest_atms[i + 1 ][1] > closest_atms[i][1]).to be_truthy }
    end
  end

  describe 'distance_between' do
    it 'returns distance for geocoords' do
      expect(Atm.distance_between(10, 30, 20, 40)).to eq 3040603
    end
  end
end
