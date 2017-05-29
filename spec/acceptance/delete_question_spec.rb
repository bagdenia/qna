require_relative 'acceptance_helper'

feature 'Delete question', %q{
I want to be able
to delete my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  scenario 'User can delete his question' do
    sign_in(user)
    visit questions_path
    qstn_title = question.title

    click_on 'delete'
    expect(page).to have_content 'Question successfully deleted'
    expect(page).to have_no_content qstn_title
  end

  scenario 'User cant delete other user question'do
    other_user = create(:user)
    sign_in(other_user)
    visit questions_path

    expect(page).to have_no_content 'delete'
  end

end
