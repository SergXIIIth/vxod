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

    def request_host
      rack_app.request.host
    end

    def params
      rack_app.params
    end

    def session
      rack_app.session
    end

    def omniauth_hash
      rack_app.env['omniauth.auth']
    end

    def authentify(auth_key, remember_me = true)
      cookie_hash = {
        value: auth_key,
        path: '/',
        httponly: true
      }

      if remember_me
        cookie_hash[:expires] = Time.new(DateTime.now.year + 10, 1, 1)
      end

      rack_app.response.set_cookie('vxod.auth', cookie_hash)      
    end

    def authentify_and_back(user, remember_me = true)
      authentify(user.auth_key, remember_me)
      redirect_to_after_login
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

    def redirect_to_fill_openid(openid)
      session['vxod.auth_openid'] = openid.id
      redirect(Vxod.config.fill_openid_path)
    end

    def current_openid
      Db.openid.find(session['vxod.auth_openid'])
    end
  end
end