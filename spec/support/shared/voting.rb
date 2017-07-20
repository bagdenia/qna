shared_examples_for "Votable" do
  scenario 'Authenticated user can vote and unvote', js: true do
    sign_in user
    visit_page

    within  "#{obj_class} .votes" do
      expect(page).to have_content 0
      click_link 'vote_up'
      expect(page).to have_content 1
      expect(page).to_not have_css 'glyphicon-thumbs-up'
      expect(page).to have_css '.glyphicon-remove'
      click_link 'unvote'
      expect(page).to have_content 0
    end
  end

  scenario 'Authenticated user cant vote his answer', js: true do
    sign_in other_user
    visit_page

    within  "#{obj_class} .votes" do
      expect(page).to have_content 0
      expect(page).to_not have_css 'glyphicon-thumbs-up'
      expect(page).to_not have_css 'glyphicon-thumbs-down'
      expect(page).to_not have_css '.glyphicon-remove'
    end
  end

end
