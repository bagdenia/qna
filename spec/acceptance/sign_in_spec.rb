require_relative 'acceptance_helper'

feature 'User sign in', %q{
  In order to be able ask question
  As a user
  I want to be able to sign in
} do
  given(:user) { create(:user) }
  scenario 'Registered user try to sign in', js: true do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Non registered user try to sign in', js: true do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'User can sign_up', js: true do
    visit new_user_registration_path

    fill_in 'Email', with: 'fafa@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'message with a confirmation link'
    expect(current_path).to eq root_path
  end



end
