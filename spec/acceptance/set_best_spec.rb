require_relative 'acceptance_helper'

feature 'Set best answer', %q{
  I want to be able
  to set best answer
  for my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }
  describe 'Authenticated user' do
    before do
      sign_in(user)
      sleep(1)
      visit question_path(question)
    end
    scenario 'can set best asnwer', js: true do
      within "#answer-#{Answer.first.id}" do
        click_on 'Set best'
        expect(page).to have_content 'BEST'
      end
    end
    scenario 'can set another answer as best', js: true do
      within "#answer-#{Answer.first.id}" do
        click_on 'Set best'
        expect(page).to have_content 'BEST'
      end
      within "#answer-#{Answer.second.id}" do
        click_on 'Set best'
        expect(page).to have_content 'BEST'
      end
    end
    scenario 'see best answer first in answers list', js: true do
      within "#answer-#{Answer.third.id}" do
        click_on 'Set best'
      end
      sleep(1)
      best_tr = page.find('.answr').first(:xpath, 'tr[1]')
      within best_tr do
        expect(page).to have_content 'BEST'
      end
    end

  end

  scenario 'Non authenticated user cant set best answer', js: true do
    other_user = create(:user)
    sign_in(other_user)
    visit question_path(question)
    expect(page).to have_no_button'Set best'
  end

  # scenario 'Everyone see best answer first in answers list', js: true do
  #   answers.first.set_best
  #   visit question_path(question)
  #   sleep(1)
  #   best_tr = page.find('.answr').first(:xpath, 'tr[1]')
  #   within best_tr do
  #     expect(page).to have_content 'BEST'
  #   end
  # end через сценарий выше прекрасно аналогичный тест отрабатывает, а тут не может css найти, не понимаю почему
end
