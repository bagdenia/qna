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

  scenario 'User add file when ask question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'why why why'

    click_on 'add file'
    click_on 'add file'
    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end

end

