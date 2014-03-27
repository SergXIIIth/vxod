module Vxod
  class Api
    def initialize(rack_app)
      @rack_app = rack_app
    end

    attr_reader :rack_app

    # Check that user login and have right to make 'action' on 'object'
    # If not it redirects to login page
    def required(action = nil, object = nil)
      back_path = BackPath.new(rack_app)
      path = back_path.store_in(Vxod.config.login_path)
      app.redirect(path)
    end

    def login_with_openid
      @openid ||= LoginWithOpenid.new(app)
      @openid.login
    end

    # Return user for fill user data page
    def user_to_fill_data
      Db.user.find_by_auth_key(app.auth_key_for_fill_user_data)
    end

    # Current user
    def user
      Db.user.find_by_auth_key(app.auth_key)
    end

  private

    def app
      @app ||= Vxod::App.new(rack_app)
    end
  end
end