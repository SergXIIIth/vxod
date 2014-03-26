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

  private

    def app
      @app ||= Vxod::App.new(rack_app)
    end
  end
end