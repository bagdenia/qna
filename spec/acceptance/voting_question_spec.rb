require_relative 'acceptance_helper'

feature 'Voting for item', %q{
User can vote item
he liked
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: other_user) }
  scenario 'Authenticated user can vote and unvote the question', js: true do
    sign_in user
    visit questions_path

    within  '.qstn .votes' do
      expect(page).to have_content 0
      click_link 'vote_up'
      expect(page).to have_content 1
      expect(page).to_not have_css 'glyphicon-thumbs-up'
      expect(page).to have_css '.glyphicon-remove'
      click_link 'unvote'
      expect(page).to have_content 0
    end
  end
  scenario 'Authenticated user cant vote his question', js: true do
    sign_in other_user
    visit questions_path

    within  '.qstn .votes' do
      expect(page).to have_content 0
      expect(page).to_not have_css 'glyphicon-thumbs-up'
      expect(page).to_not have_css 'glyphicon-thumbs-down'
      expect(page).to_not have_css '.glyphicon-remove'
    end
  end
end
