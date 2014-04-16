module Vxod
  class OpenidLogin
    def initialize(app)
      @app = app
    end

    attr_reader :app

    def login
      openid = OpenidRepo.find_or_create(app.omniauth_hash)

      if openid.user
        app.authentify_and_back(openid.user)
      else
        registrator.register_by_openid(openid)
      end
    end

    def update_openid_data
      registrator.register_by_clarify_openid(app.current_openid)
    end

    def show_openid_data
      openid = app.current_openid
      user = openid.user 
      user ||= UserRepo.build_by_openid(openid)

      user.valid? # fill up user#errors

      user
    end

    private 

    def registrator
      Registrator.new(app)
    end
  end
end