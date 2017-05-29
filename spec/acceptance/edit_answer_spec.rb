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
      sleep(2)
      visit question_path(question)

    end
    scenario 'sees link to edit' do
      within '.answr' do
        expect(page).to have_link 'edit'
      end
    end

    scenario 'try to edit his answer', js: true do
      click_on 'edit'
      within '.answr' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        #expect(page).to_not have_selector 'textarea'
      end
    end


    scenario 'try to edit other user question' do

    end

  end
end
