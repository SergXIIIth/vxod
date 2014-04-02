module Vxod
  class Api
    def initialize(rack_app)
      @rack_app = rack_app
    end

    attr_reader :rack_app

    # Authorize user right to make action on object
    #
    # Check that user login and have right to make 'action' on 'object'
    # If not it redirects to login page
    def required(action = nil, object = nil)
      if user.nil?
        BackPath.new(rack_app).save(app.request_path)
        app.redirect(Vxod.config.login_path)
      else
        true
      end
    end

    def redirect_back
      app.redirect_to_after_login
    end

    def login_with_openid
      openid.login
    end

    def register
      Registrator.new(app).register
    end

    def logout
      app.detele_auth_key
      app.redirect(Vxod.config.after_login_default_path)
    end

    def update_openid_data
    end

    def show_openid_data
    end

    # Current user
    def user
      @user ||= Db.user.find_by_auth_key(app.auth_key)
    end

  private

    def openid
      @openid ||= OpenidLogin.new(app)
    end

    def app
      @app ||= Vxod::App.new(rack_app)
    end
  end
end