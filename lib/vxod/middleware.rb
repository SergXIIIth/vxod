require 'omniauth'


module Vxod
  class Middleware < Sinatra::Base
    require 'vxod/middleware/helpers'
    require 'vxod/middleware/assets'

    helpers Helpers
    register Assets

    set :views, "#{__dir__}/middleware/views"

    # Login

    get Vxod.config.login_path do
      slim :login, locals: { login_form: LoginForm.new }
    end

    post Vxod.config.login_path do
      call_vxod_api :login, :login
    end

    get Vxod.config.logout_path do
      vxod.logout
    end

    # Registration

    get Vxod.config.registration_path do
      render_view :registration, Db.user.new
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
      # p env['omniauth.auth']
      call_vxod_api :login_with_openid, :login
    end

    post "#{OmniAuth.config.path_prefix}/:provider/callback" do
      # p env['omniauth.auth']
      call_vxod_api :login_with_openid, :login
    end
  end
end
