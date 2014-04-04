require 'sinatra/base'
require 'vxod/version'
require 'pony'

module Vxod
  autoload :Db, 'vxod/db'
  autoload :BackPath, 'vxod/back_path'
  autoload :Config, 'vxod/config'
  autoload :App, 'vxod/app'
  autoload :Api, 'vxod/api'
  autoload :OpenidRawParser, 'vxod/openid_raw_parser'
  autoload :UserRepo, 'vxod/user_repo'
  autoload :OpenidRepo, 'vxod/openid_repo'
  autoload :Notify, 'vxod/notify'
  autoload :ConfirmEmail, 'vxod/confirm_email'
  autoload :Registrator, 'vxod/registrator'
  autoload :OpenidLogin, 'vxod/openid_login'
  require 'vxod/api_static'
  autoload :OmniAuthProvider, 'vxod/omni_auth_provider'
  autoload :MiddlewareHelpers, 'vxod/middleware/helpers'
  autoload :MiddlewareAssets, 'vxod/middleware/assets'
  autoload :Middleware, 'vxod/middleware/middleware'
end