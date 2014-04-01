module Vxod
  class LoginWithOpenid
    def initialize(app)
      @app = app
    end

    attr_reader :app

    def login
      openid = Db.openid.find_by_openid(provider, uid)

      user = if openid.nil?
        User.create_openid(provider, uid, email, firstname, lastname)
      else
        openid.user
      end

      if Email.valid?(user.email)
        app.authentify(user.auth_key)
        app.redirect_to_after_login
      else
        app.authentify_for_fill_user_data(user.auth_key)
        app.redirect(Vxod.config.fill_user_data_path)
      end
    end

    def save_user_data
      if Email.valid?(app.params['email'])
        user = Db.user.find_by_auth_key(app.auth_key_for_fill_user_data)
        user.email      = app.params['email']
        user.firstname  = app.params['firstname']
        user.lastname   = app.params['lastname']
        user.save!

        app.authentify(user.auth_key)
        app.redirect_to_after_login
      else
        false
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

    def uid
      app.omniauth_hash[:uid]
    end

    def provider
      app.omniauth_hash[:provider]
    end
  end
end