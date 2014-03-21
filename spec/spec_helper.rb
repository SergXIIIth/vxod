ENV['RACK_ENV'] ||= 'test'

require 'rack/test'
require 'vxod'

Dir["#{__dir__}/support/**/*.rb"].each{ |path| require path }

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.fail_fast = true
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.include Rack::Test::Methods
  config.include CustomHelpers
end