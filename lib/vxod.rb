require 'sinatra/base'
require 'vxod/version'

module Vxod
  autoload :Db, 'vxod/db'
  autoload :Email, 'vxod/email'
  autoload :BackPath, 'vxod/back_path'
  autoload :Config, 'vxod/config'
  autoload :App, 'vxod/app'
  autoload :Api, 'vxod/api'
  autoload :LoginWithOpenid, 'vxod/login_with_openid'
  require 'vxod/api_static'
  autoload :OmniAuthProvider, 'vxod/omni_auth_provider'
  autoload :Middleware, 'vxod/middleware'
end