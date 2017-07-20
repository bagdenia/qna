require_relative 'acceptance_helper'

feature 'Voting for item', %q{
User can vote item
he liked
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: other_user) }
  given!(:answer) { create(:answer, question: question, user: other_user) }
  given(:obj_class){ '.answr'}

  it_behaves_like "Votable"

  def visit_page
    visit question_path question
  end
end

