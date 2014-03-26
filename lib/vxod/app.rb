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
        domain: rack_app.request.host,
        path: '/',
        expires: Date.new(DateTime.now.year + 10, 1, 1)
      )      
    end

    def authentify_for_fill_user_data(auth_key)
      rack_app.response.set_cookie('vxod.auth_fill_user_data', 
        value: auth_key,
        domain: rack_app.request.host,
        path: Vxod.config.fill_user_data_path
      )      
    end

    def after_login_path
      BackPath.new(rack_app).get
    end
  end
end