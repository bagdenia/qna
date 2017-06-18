require_relative 'acceptance_helper'

feature 'Show question and it-s answer', %q{
  I want to be able
  to see question view
  and list of all answers for it
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }
  #background { create_list(:question, 2) }
  scenario 'Authenticated user browses questions list', js: true do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.answers.first.body
    expect(page).to have_content question.answers.second.body
  end

  scenario 'Non-authenticated user browses questions list', js: true do
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.answers.first.body
    expect(page).to have_content question.answers.second.body
  end
end
