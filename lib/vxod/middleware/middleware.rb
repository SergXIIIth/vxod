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
      call_vxod_api :register, :registration
    end

    get Vxod.config.logout_path do
      vxod.logout
    end

    get Vxod.config.fill_openid_path do
      call_vxod_api :show_openid_data, :fill_openid_data
    end

    post Vxod.config.fill_openid_path do
      call_vxod_api :update_openid_data, :fill_openid_data
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