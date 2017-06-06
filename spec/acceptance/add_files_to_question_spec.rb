require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to iilustrate my question
  As a question's author
  I'd like to be able to attach files
} do
  given(:user) { create(:user) }
  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User add file when ask question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'why why why'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_content 'spec_helper.rb'



  end

end

