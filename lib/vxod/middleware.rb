require 'omniauth'


module Vxod
  class Middleware < Sinatra::Base
    require 'vxod/middleware/helpers'

    helpers Helpers

    set :views, "#{__dir__}/middleware/views"

    # Login

    get Vxod.config.login_path do
      env['VXOD.HTML'] = slim(:login, locals: { login_form: LoginForm.new })
      pass
    end

    post Vxod.config.login_path do
      env['VXOD.HTML'] = slim(:login, locals: { login_form: vxod.login })
      pass
    end

    get Vxod.config.logout_path do
      vxod.logout
    end

    # Registration

    get Vxod.config.registration_path do
      env['VXOD.HTML'] = slim(:registration, locals: { user: Db.user.new })
      pass
    end

    post Vxod.config.registration_path do
      env['VXOD.HTML'] = slim(:registration, locals: { user: vxod.register })
      pass
    end

    get Vxod.config.confirm_email_path do
      slim :confirm_email, locals: vxod.confirm_email
    end

    # OpenId

    get Vxod.config.fill_openid_path do
      html = slim :fill_openid, locals: { user: vxod.show_openid_data }
      env['VXOD.HTML'] = html
      pass
    end

    post Vxod.config.fill_openid_path do
      html = slim :fill_openid, locals: { user: vxod.update_openid_data }
      env['VXOD.HTML'] = html
      pass
    end

    get "#{OmniAuth.config.path_prefix}/:provider/callback" do
      vxod.login_with_openid
    end

    post "#{OmniAuth.config.path_prefix}/:provider/callback" do
      vxod.login_with_openid
    end
  end
end
