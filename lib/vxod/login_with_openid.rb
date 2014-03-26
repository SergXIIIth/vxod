module Vxod
  class LoginWithOpenid
    def initialize(rack_app_wrap)
      @rack_app_wrap = rack_app_wrap
    end

    attr_reader :rack_app_wrap

    def login
      identity = Db.identity.find_by_openid(provider, openid)
      rack_app_wrap.authentify(identity.user.auth_key)
      rack_app_wrap.redirect_back

      # if identity.nil?
      #   identity = create_identity
      # end

      # if email_valid?(identity.email)
      #   create_user(identity) if identity.user.nil?
      #   authentify(identity)
      #   @rack_app.redirect Vxod.urls.back_after_login
      # else
      #   authentify(identity, 'temp')
      #   @rack_app.redirect Vxod.urls.please_fill_email
      # end
    end

  private

    def openid
      rack_app_wrap.omniauth_hash[:uid]
    end

    def provider
      rack_app_wrap.omniauth_hash[:provider]
    end
  end
end