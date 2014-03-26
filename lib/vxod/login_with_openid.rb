module Vxod
  class LoginWithOpenid
    def initialize(app)
      @app = app
    end

    attr_reader :app

    def login
      identity = Db.identity.find_by_openid(provider, openid)

      if identity.nil?
        identity = Db.identity_create(provider, openid, email, firstname, lastname)
      end

      if Email.valid?(identity.user.email)
        app.authentify(identity.user.auth_key)
        app.redirect(app.after_login_path)
      else
        app.authentify_for_fill_user_data(identity.user.auth_key)
        app.redirect(Vxod.config.fill_user_data_path)
      end
    end

  private

    def info
      app.omniauth_hash[:info]
    end

    def email
      if info && info[:email]
        info[:email]
      else
        nil
      end
    end

    def firstname
      if info && info[:first_name]
        info[:first_name]
      else
        nil
      end
    end

    def lastname
      if info && info[:last_name]
        info[:last_name]
      else
        nil
      end
    end

    def openid
      app.omniauth_hash[:uid]
    end

    def provider
      app.omniauth_hash[:provider]
    end
  end
end