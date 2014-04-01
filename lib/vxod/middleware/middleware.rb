require 'omniauth'

module Vxod
  class Middleware < Sinatra::Base
    helpers MiddlewareHelpers
    register MiddlewareAssets

    # Pages

    get Vxod.config.login_path do
      slim :login
    end

    get Vxod.config.registration_path do
      slim :registration, locals: { user: Db.user.new } 
    end

    post Vxod.config.registration_path do
      user = vxod.register

      if user.valid?
        vxod.redirect_back
      else
        slim :registration, locals: { user: user } 
      end
    end

    get Vxod.config.logout_path do
      vxod.logout
    end

    get Vxod.config.fill_user_data_path do
      slim :fill_user_data, locals: { user: vxod.user_to_fill_data }
    end

    post Vxod.config.fill_user_data_path do
      unless vxod.openid_save_user_data
        slim :fill_user_data, locals: { user: vxod.user_to_fill_data }
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