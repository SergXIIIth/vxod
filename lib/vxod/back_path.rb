module Vxod
  class BackPath
    def initialize(rack_app)
      @rack_app = rack_app
    end

    attr_reader :rack_app

    def save(url)
      app.session['vxod.back_path'] = url
    end

    def get
      if app.session['vxod.back_path']
        app.session['vxod.back_path']
      else
        Vxod.config.after_login_default_path
      end
    end

  private

    def app
      @app ||= Vxod::App.new(rack_app)
    end
  end
end