require_relative 'acceptance_helper'

feature 'Answer editiong', %q{
  In order to fix mistake
  As an answer author
  I want to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauth user try to edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      sleep(1)
      visit question_path(question)
    end
    scenario 'sees link to edit' do
      within '.answr' do
        expect(page).to have_link 'edit'
      end
    end

    scenario 'try to edit his answer', js: true do
      with_hidden_fields do
        within '.answr' do
          click_on 'edit'
          fill_in 'Answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          #expect(page).to_not have_selector 'textarea'
        end
      end
    end


    scenario 'try to edit other user question' do
      click_on 'Log out'
      other_user = create(:user)
      sign_in(other_user)
      visit question_path(question)
      within '.answr' do
        expect(page).to_not have_link 'edit'
      end
    end

  end
end
