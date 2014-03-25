require 'sinatra/base'

module Vxod
end

files = %w(
  version
  rack_app_wrap
  config
  api
  api_static
  omni_auth_provider
  middleware
)

files.each { |file| require "vxod/#{file}" }

