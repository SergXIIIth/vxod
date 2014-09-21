module Vxod
  class << self
    def api(rack_app)
      Vxod::Api.new(rack_app)
    end

    def config
      @config ||= Vxod::Config.new
    end

    def configure
      yield config
    end
  end
end
