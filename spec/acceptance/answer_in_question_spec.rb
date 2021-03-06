require_relative 'acceptance_helper'

feature 'Create answer in show question', %q{
I want to be able
to give my answer at question page
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  scenario 'Authenticated user try to give answer to the question', js: true do
    sign_in(user)
    visit question_path question

    fill_in 'Your answer', with: 'My answer'
    click_on 'Create'

    within  '.answr' do
      expect(page).to have_content 'My answer'
    end
  end

  scenario 'Non-authenticated user try to give answer to the question', js: true do
    visit question_path question
    expect(page).to have_no_content 'Your answer'
  end

  scenario 'User try to create invalid answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Create'
    wait_for_ajax

    expect(page).to have_content "Body can't be blank"
  end

  fcontext "muliple sessions" do
    scenario "answer appears on other users page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
      Capybara.using_session('guest') do
        visit question_path(question)
      end
      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'My answer'
        click_on 'Create'
        expect(page).to have_content 'My answer'
      end
      Capybara.using_session('guest') do
        expect(page).to have_content 'My answer'
      end
    end
  end

end

