require_relative 'acceptance_helper'

feature 'Create comment in show question', %q{
I want to be able
to  leave my comment at question page
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  scenario 'Authenticated user try to leave comment to the question', js: true do
    sign_in(user)
    visit question_path question

    within '.show-comments-question' do
      click_on 'Show comments'
      click_on 'New comment'
    end
    within '.new_comment' do
      fill_in 'Your comment', with: 'My comment'
      click_on 'Create'
    end
    expect(page).to have_content 'My comment'
  end

  scenario 'Authenticated user try to leave comment to the answer', js: true do
    sign_in(user)
    visit question_path question

    within '.answr' do
      click_on 'Show comments'
      click_on 'New comment'
    end
    within '.new_comment' do
      fill_in 'Your comment', with: 'My comment'
      click_on 'Create'
    end
    expect(page).to have_content 'My comment'
  end

  scenario 'Nonauthenticated user cant leave comment', js: true do
    visit question_path question
    expect(page).to have_no_content 'New comment'
  end

  context "muliple sessions" do
    scenario "comment appears on other users page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path question

      end
      Capybara.using_session('guest') do
        visit question_path question
      end
      Capybara.using_session('user') do
        within '.show-comments-question' do
          click_on 'Show comments'
          click_on 'New comment'
        end
        within '.new_comment' do
          fill_in 'Your comment', with: 'My comment'
          click_on 'Create'
        end
        expect(page).to have_content 'My comment'
      end
      Capybara.using_session('guest') do
        pry
        within '.show-comments-question' do
          click_on 'Show comments'
        end
        expect(page).to have_content 'My comment'
      end

    end
  end
end
