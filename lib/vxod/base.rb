module Vxod
  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path += Dir[File.join(__dir__, 'locales', '*.yml')]
  I18n.backend.load_translations

  autoload :Db, 'vxod/db'
  autoload :LoginForm, 'vxod/login_form'
  autoload :BackPath, 'vxod/back_path'
  autoload :Config, 'vxod/config'
  autoload :App, 'vxod/app'
  autoload :Api, 'vxod/api'
  autoload :OpenidRawParser, 'vxod/openid_raw_parser'
  autoload :UserRepo, 'vxod/user_repo'
  autoload :OpenidRepo, 'vxod/openid_repo'
  autoload :Notify, 'vxod/notify'

  autoload :ConfirmEmail, 'vxod/services/confirm_email'
  autoload :Registrator, 'vxod/services/registrator'
  autoload :Login, 'vxod/services/login'
  autoload :OpenidLogin, 'vxod/services/openid_login'

  require 'vxod/api_static'
  autoload :OmniAuthProvider, 'vxod/omni_auth_provider'
end
