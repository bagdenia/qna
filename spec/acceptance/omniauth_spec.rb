require_relative 'acceptance_helper'

feature 'Authenticate with OmniAuth', %q{
  I want to be able
  to login using social networks
} do
  given(:user) { create(:user) }
  describe "User try to login using FB" do
    scenario "New user first time try to login using facebook", js: true do
      visit new_user_session_path
      expect(page).to have_content('Sign in with Facebook')
      mock_auth_hash(:facebook)
      click_on 'Sign in with Facebook'
      expect(page).to have_content('You have to confirm your email address before continuing')
      message = ActionMailer::Base.deliveries.last.body.raw_source
      doc = Nokogiri::HTML.parse(message)
      url = doc.css("a").map { |link| link[:href] }.first
      visit url
      expect(page).to have_content('Your email address has been successfully confirmed')
      click_on 'Sign in with Facebook'
      expect(page).to have_content('Successfully authenticated from facebook account')
    end

    scenario "Existing user first time try to login using FB", js: true do
      auth = mock_auth_hash(:facebook)
      user.update!(email: auth.info.email)
      user.update!(confirmed_at: DateTime.now)
      visit new_user_session_path
      expect(page).to have_content('Sign in with Facebook')
      click_on 'Sign in with Facebook'
      expect(page).to have_content('You have to confirm your email address before continuing')
      message = ActionMailer::Base.deliveries.last.body.raw_source
      doc = Nokogiri::HTML.parse(message)
      url = doc.css("a").map { |link| link[:href] }.first
      visit url
      expect(page).to have_content('Your email address has been successfully confirmed')
      click_on 'Sign in with Facebook'
      expect(page).to have_content('Successfully authenticated from facebook account')
    end

    scenario "Existing authorized FB user try again to login using FB", js: true do
      auth = mock_auth_hash(:facebook)
      user.update!(email: auth.info.email)
      user.update!(confirmed_at: DateTime.now)
      authorization = create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
      visit new_user_session_path
      click_on 'Sign in with Facebook'
      expect(page).to have_content('Successfully authenticated from facebook account')
    end
  end

  describe "New user try to login using VK" do
    scenario "User first time try to login using VK", js: true do
      visit new_user_session_path
      expect(page).to have_content('Sign in with Vkontakte')
      mock_auth_hash(:vkontakte)
      click_on 'Sign in with Vkontakte'
      expect(page).to have_content('Email')
      fill_in 'auth_info_email', with: "bagdenia@mail.ru"
      click_on 'Submit'
      expect(page).to have_content('You have to confirm your email address before continuing')
      message = ActionMailer::Base.deliveries.last.body.raw_source
      doc = Nokogiri::HTML.parse(message)
      url = doc.css("a").map { |link| link[:href] }.first
      visit url
      expect(page).to have_content('Your email address has been successfully confirmed')
      click_on 'Sign in with Vkontakte'
      expect(page).to have_content('Successfully authenticated from vkontakte account')
    end

    scenario "Existing user first time try to login using VK", js: true do
      auth = mock_auth_hash(:vkontakte)
      user.update!(email: 'vk@mail.ru')
      user.update!(confirmed_at: DateTime.now)
      visit new_user_session_path
      expect(page).to have_content('Sign in with Vkontakte')
      click_on 'Sign in with Vkontakte'
      expect(page).to have_content('Email')
      fill_in 'auth_info_email', with: "vk@mail.ru"
      click_on 'Submit'
      expect(page).to have_content('You have to confirm your email address before continuing')
      message = ActionMailer::Base.deliveries.last.body.raw_source
      doc = Nokogiri::HTML.parse(message)
      url = doc.css("a").map { |link| link[:href] }.first
      visit url
      expect(page).to have_content('Your email address has been successfully confirmed')
      click_on 'Sign in with Vkontakte'
      expect(page).to have_content('Successfully authenticated from vkontakte account')
    end

    scenario "Existing authorized VK user try again to login using VK", js: true do
      auth = mock_auth_hash(:vkontakte)
      user.update!(email: 'vk@mail.ru')
      user.update!(confirmed_at: DateTime.now)
      authorization = create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
      visit new_user_session_path
      click_on 'Sign in with Vkontakte'
      expect(page).to have_content('Successfully authenticated from vkontakte account')
    end
  end
end
