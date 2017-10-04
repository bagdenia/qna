require_relative 'acceptance_helper'

feature 'Closest atms list for given point', %q{
  I want to get 5 closest atms
} do

  given!(:atms) { create_list(:atm, 10) }
  scenario 'I can get them 5' do
    visit closest_atms_path
    expect(page).to have_css 'form.closest-atms'

    fill_in 'Lat', with: atms.first.lat
    fill_in 'Lng', with: atms.first.lng
    click_on 'Submit'

    expect(page).to have_content atms.first.address
    expect(page).to have_css('.closest-item', count: 5)
  end
end
