require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do
  given(:user) { create(:user) }
  scenario 'Authenticated user creates question', js: true do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'why why why'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created'
    expect(page).to have_content 'Test question'
  end

  scenario 'Non-authenticated user tries to create question', js: true do
    visit questions_path

    expect(page).to have_no_content 'Ask question'
  end

  context "muliple sessions" do
    scenario "question appears on other users page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end
      Capybara.using_session('guest') do
        visit questions_path
      end
      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'why why why'
        click_on 'Create'
        expect(page).to have_content 'Your question successfully created'
        expect(page).to have_content 'Test question'
      end
      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end

    end
  end
end
