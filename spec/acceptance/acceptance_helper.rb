require 'rails_helper'
#require 'capybara/poltergeist'

RSpec.configure do |config|
  #Capybara.javascript_driver = :webkit
  #Capybara.javascript_driver = :poltergeist
  Capybara.server = :puma
  Capybara.server_host = "0.0.0.0"
  Capybara.server_port = 5000
  Capybara.default_wait_time = 5
  config.include AcceptanceHelper, type: :feature


  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
