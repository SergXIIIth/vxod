ENV['RACK_ENV'] ||= 'test'

require 'rack/test'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'vxod'

Dir["#{__dir__}/support/**/*.rb"].each{ |path| require path }

Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 15 # for CI
# Capybara.default_driver = :selenium

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  # config.fail_fast = true
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.include Rack::Test::Methods
  config.include CustomHelpers

  # feature

  config.before :each, :feature do
    require_relative '../example/app.rb'

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