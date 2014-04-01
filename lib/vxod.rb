require 'sinatra/base'
require 'vxod/version'

module Vxod
  autoload :Db, 'vxod/db'
  autoload :Email, 'vxod/email'
  autoload :BackPath, 'vxod/back_path'
  autoload :Config, 'vxod/config'
  autoload :App, 'vxod/app'
  autoload :Api, 'vxod/api'
  autoload :User, 'vxod/user'
  autoload :Registrator, 'vxod/registrator'
  autoload :LoginWithOpenid, 'vxod/login_with_openid'
  require 'vxod/api_static'
  autoload :OmniAuthProvider, 'vxod/omni_auth_provider'
  autoload :MiddlewareHelpers, 'vxod/middleware/helpers'
  autoload :MiddlewareAssets, 'vxod/middleware/assets'
  autoload :Middleware, 'vxod/middleware/middleware'
end