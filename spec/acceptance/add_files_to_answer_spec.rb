require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to iilustrate my answer
  As a answer's author
  I'd like to be able to attach files
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  it_behaves_like "Attachable"

  def fill_obj
    fill_in 'Your answer', with: 'My answer'
  end
end

