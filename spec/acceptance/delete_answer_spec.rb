require 'rails_helper'

feature 'Delete answer', %q{
I want to be able
to delete my answer at question page
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question)}
  scenario 'User can delete his answer' do
    sign_in(user)
    visit question_path question

    click_on 'delete'
    expect(page).to have_content 'Answer successfully deleted'
  end

  scenario 'User cant delete other user answer'do
    other_user = create(:user)
    sign_in(other_user)
    visit question_path question

    expect(page).to have_no_content 'delete'
  end

end
