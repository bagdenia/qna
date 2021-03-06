require_relative 'acceptance_helper'

feature 'Show questions list', %q{
  I want to be able
  to browse list of all questions
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2) }
  #background { create_list(:question, 2) }
  scenario 'Authenticated user browses questions list', js: true do
    sign_in(user)

    visit questions_path
    expect(page).to have_content Question.first.title
  end

  scenario 'Non-authenticated user browses questions list', js: true do
    visit questions_path
    expect(page).to have_content Question.first.title
  end
end
