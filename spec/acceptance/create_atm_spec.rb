require_relative 'acceptance_helper'

feature 'Create atm at index page', %q{
  I want to be able to create new atm
} do
  scenario 'I can create atm', js: :true do
    visit atms_path
    expect(page).to have_css 'form.new_atm'

    fill_in 'Address', with: 'Test address'
    fill_in 'Lat', with: 50
    fill_in 'Lng', with: 100
    click_on 'Create'
    wait_for_ajax

    expect(page).to have_content 'Test address'
    expect(page).to have_content 50
    expect(page).to have_content 100
  end
end
