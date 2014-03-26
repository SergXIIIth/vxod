require 'sinatra/base'
require 'vxod/version'

module Vxod
  autoload :Db, 'vxod/db'
  autoload :Config, 'vxod/config'
  autoload :RackAppWrap, 'vxod/rack_app_wrap'
  autoload :Api, 'vxod/api'
  autoload :LoginWithOpenid, 'vxod/login_with_openid'
  require 'vxod/api_static'
  autoload :OmniAuthProvider, 'vxod/omni_auth_provider'
  autoload :Middleware, 'vxod/middleware'
end