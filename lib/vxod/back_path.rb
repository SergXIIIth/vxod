module Vxod
  class BackPath
    def initialize(rack_app)
      @rack_app = rack_app
    end

    attr_reader :rack_app

    def store_in(url)
      "#{url}?back=#{URI.escape(app.request_path)}"
    end

    def add_to(url)
      if app.params['back']
        "#{url}?back=#{URI.escape(app.params['back'])}"
      else
        url
      end
    end

    def get
    end

  private

    def app
      @app ||= Vxod::App.new(rack_app)
    end
  end
end