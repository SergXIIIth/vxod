module Vxod
  class OpenidRawParser
    def initialize(omniauth_hash)
      @omniauth_hash = omniauth_hash
    end

    attr_reader :omniauth_hash

    def email
      if info && info['email']
        info['email']
      else
        nil
      end
    end

    def firstname
      if info && info['first_name']
        info['first_name']
      else
        nil
      end
    end

    def lastname
      if info && info['last_name']
        info['last_name']
      else
        nil
      end
    end

    def uid
      omniauth_hash['uid']
    end

    def provider
      omniauth_hash['provider']
    end

    private

    def info
      omniauth_hash['info']
    end

  end
end