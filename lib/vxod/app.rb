# Responsibility - have one API for all frameworks
# Wrap on Rack frameworks (Sinatra, Rails ...)
module Vxod
  class App
    def initialize(rack_app)
      @rack_app = rack_app
    end

    attr_reader :rack_app

    def redirect(url)
      rack_app.redirect(url)
    end

    def request_path
      rack_app.request.path
    end

    def params
      rack_app.params
    end

    def omniauth_hash
      rack_app.env['omniauth.auth']
    end

    def authentify(auth_key)
      rack_app.response.set_cookie('vxod.auth', 
        value: auth_key,
        path: '/',
        expires: Time.new(DateTime.now.year + 10, 1, 1),
        httponly: true,
      )      
    end

    def authentify_for_fill_user_data(auth_key)
      rack_app.response.set_cookie('vxod.auth_fill_user_data', 
        value: auth_key,
        path: Vxod.config.fill_user_data_path,
        httponly: true,
      )      
    end

    def auth_key_for_fill_user_data
      rack_app.request.cookies['vxod.auth_fill_user_data']
    end

    def auth_key
      rack_app.request.cookies['vxod.auth']
    end

    def detele_auth_key
      rack_app.response.set_cookie('vxod.auth', nil)
    end

    def after_login_path
      BackPath.new(rack_app).get
    end

    def redirect_to_after_login
      redirect(after_login_path)
    end
  end
end