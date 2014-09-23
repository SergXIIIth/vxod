ENV['RACK_ENV'] ||= 'test'

require 'rack/test'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'vxod'

Dir["#{__dir__}/support/**/*.rb"].each{ |path| require path }

# Capybara.default_wait_time = 15 # for CI
Capybara.javascript_driver = :poltergeist
# Capybara.default_driver = :selenium

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  # config.fail_fast = true

  config.include Rack::Test::Methods

  config.include Capybara::DSL, :feature
  config.include Capybara::RSpecMatchers, :feature

  # feature

  config.before :each, :feature do
    require_relative 'app/app.rb'

    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
      provider:   'vkontakte',
      uid:        '12345',
      extra:      {raw: {}},
      info:       {
                    first_name: 'Sergey',
                    last_name:  'Makridenkov',
                    email:      '',
                  }
    )

    OmniAuth.config.test_mode = true

    Mongoid.purge!

    Capybara.app = Sinatra::Application
  end
end
