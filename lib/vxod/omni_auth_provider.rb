# Provide list of supported providers with metadata (title, icon)
# Detect provider usage in hosting app
module Vxod
  class OmniAuthProvider
    def initialize(id)
      @id = id
    end

    attr_reader :id

    def show?
      @show ||= begin
        OmniAuth::Strategies.const_get("#{OmniAuth::Utils.camelize(id.to_s)}")
        true
      rescue NameError
        false
      end
    end

    def href
      "#{OmniAuth.config.path_prefix}/#{id}"
    end

    class << self
      def any?
        all.any?{ |provider| provider.show? }
      end

      def all
        @all ||= %i(vkontakte twitter facebook google_oauth2 github)
          .map{ |id| new(id) }
      end
    end
  end
end
