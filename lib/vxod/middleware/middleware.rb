require 'omniauth'

module Vxod
  class Middleware < Sinatra::Base
    helpers MiddlewareHelpers
    register MiddlewareAssets

    # Pages

    get Vxod.config.login_path do
      slim :login
    end

    post Vxod.config.login_path do
      (params['remember_me'] == 'on').to_s
    end

    get Vxod.config.registration_path do
      slim :registration, locals: { user: Db.user.new } 
    end

    post Vxod.config.registration_path do
      user = vxod.register
      unless user.valid?
        slim :registration, locals: { user: user } 
      end
    end

    get Vxod.config.logout_path do
      vxod.logout
    end

    get Vxod.config.fill_openid_path do
      user = vxod.show_openid_data
      unless user.valid?
        slim :fill_user_data, locals: { user: user }
      end
    end

    post Vxod.config.fill_openid_path do
      user = vxod.update_openid_data
      unless user.valid?
        slim :fill_user_data, locals: { user: user }
      end
    end

    # OpenId

    get "#{OmniAuth.config.path_prefix}/:provider/callback" do
      vxod.login_with_openid
    end

    post "#{OmniAuth.config.path_prefix}/:provider/callback" do
      vxod.login_with_openid
    end
  end
end