require_relative 'acceptance_helper'

feature 'Delete file', %q{
I want to be able
to delete my file at answer page
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question)}
  given!(:attachment) { create(:attachment, attachmentable: answer) }
  scenario 'User can delete his file', js: true do
    sign_in(user)
    visit question_path question
    within "div#file-#{attachment.id}" do
      click_on 'delete'
      page.driver.browser.switch_to.alert.accept
      wait_for_ajax
      expect(page).to have_no_content attachment.file.identifier
    end
  end

  scenario 'User cant delete other user file'do
    other_user = create(:user)
    sign_in(other_user)
    visit question_path question
    within "div#file-#{attachment.id}" do
      expect(page).to have_no_content "delete"
    end
  end

  scenario 'Non-authenticated user cant delete file' do
    visit question_path question
    within "div#file-#{attachment.id}" do
      expect(page).to have_no_content "delete"
    end
  end
end
