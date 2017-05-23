require 'rails_helper'

feature 'Create answer in show question', %q{
I want to be able
to give my answer at question page
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  scenario 'Authenticated user try to give answer to the question' do
    sign_in(user)
    visit question_path question

    fill_in 'Your answer', with: 'My answer'
    click_on 'Create'


    expect(page).to have_content 'Your answer successfully created'
    expect(page).to have_content 'My answer'
  end

end

