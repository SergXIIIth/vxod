require 'sinatra/base'
require 'vxod/version'

module Vxod
  autoload :RackAppWrap, 'vxod/rack_app_wrap'
  autoload :Config, 'vxod/config'
  autoload :Api, 'vxod/api'
  require 'vxod/api_static'
  autoload :OmniAuthProvider, 'vxod/omni_auth_provider'
  autoload :Middleware, 'vxod/middleware'
end