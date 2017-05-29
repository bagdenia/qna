require_relative 'acceptance_helper'

feature 'User log out', %q{
  want to be able to log out
} do

  scenario 'Registered user try to log out' do
    user = create(:user)
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully'
    expect(current_path).to eq root_path
  end
end


