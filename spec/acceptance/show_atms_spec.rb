require_relative 'acceptance_helper'

feature 'Index atms list', %q{
  I want to get list of atms
} do
  given!(:atms) { create_list(:atm, 10) }
  scenario 'I can see all atms' do
    visit atms_path
    expect(page).to have_content 'ATM list'
    atms.each do |atm|
      expect(page).to have_content atm.address
      expect(page).to have_content atm.lat
      expect(page).to have_content atm.lng
    end
  end


end
