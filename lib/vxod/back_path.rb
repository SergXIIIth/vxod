module Vxod
  class BackPath
    def initialize(rack_app)
      @rack_app = rack_app
    end

    attr_reader :rack_app

    def save(url)
      app.session['vxod.back_path'] = url
    end

    def add_to(url)
      if app.params['back']
        "#{url}?back=#{URI.escape(app.params['back'])}"
      else
        url
      end
    end

    def get
      if app.params['back']
        URI.decode(app.params['back'])
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