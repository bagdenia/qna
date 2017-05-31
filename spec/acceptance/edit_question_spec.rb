require_relative 'acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an question author
  I want to edit my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauth user try to edit question' do
    visit questions_path
    expect(page).to_not have_link 'edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      sleep(2)
      visit questions_path
      sleep(2)
    end
    scenario 'sees link to edit' do
      within '.qstn' do
        expect(page).to have_link 'edit'
      end
    end

    scenario 'try to edit his question', js: true do
      click_on 'edit'
      sleep(2)
      within '.qstn' do
        fill_in 'Title', with: 'edited question'
        sleep(2)
        click_on 'Save'
        sleep(2)
        #pry
        expect(page).to_not have_content question.title
        expect(page).to have_content 'edited question'
        #expect(page).to_not have_selector 'textarea'
      end
    end


    scenario 'try to edit other user question' do
      click_on 'Log out'
      other_user = create(:user)
      sign_in(other_user)
      visit questions_path
      within '.qstn' do
        expect(page).to_not have_link 'edit'
      end
    end

  end
end
