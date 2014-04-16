require 'omniauth'

module Vxod
  class Middleware < Sinatra::Base
    helpers MiddlewareHelpers
    register MiddlewareAssets

    # Login

    get Vxod.config.login_path do
      slim :login, locals: { model: Success.new }
    end

    post Vxod.config.login_path do
      model = vxod.login
      
      if model.error?
        slim :login, locals: { model: model }
      end
    end

    get Vxod.config.logout_path do
      vxod.logout
    end

    # Registration

    get Vxod.config.registration_path do
      slim :registration, locals: { user: Db.user.new } 
    end

    post Vxod.config.registration_path do
      call_vxod_api :register, :registration
    end

    get Vxod.config.confirm_email_path do
      slim :confirm_email, locals: vxod.confirm_email
    end

    # OpenId

    get Vxod.config.fill_openid_path do
      call_vxod_api :show_openid_data, :fill_openid_data
    end

    post Vxod.config.fill_openid_path do
      call_vxod_api :update_openid_data, :fill_openid_data
    end

    get "#{OmniAuth.config.path_prefix}/:provider/callback" do
      vxod.login_with_openid
    end

    post "#{OmniAuth.config.path_prefix}/:provider/callback" do
      vxod.login_with_openid
    end
  end
end