module Vxod
  class OpenidLogin
    def initialize(app)
      @app = app
    end

    attr_reader :app

    def login
      openid = OpenidRepo.find_or_create(app.omniauth_hash)
      user = UserRepo.find_by_openid(openid) 

      if user
        app.authentify_and_back(user)
      else
        registrator.register_by_openid(openid)
      end
    end

    def update_openid_data
      openid = app.current_openid

      user = registrator.register

      if user.valid?
        openid.user = user
        openid.save!
      end

      user
    end

    def show_openid_data
      openid = app.current_openid
      user = UserRepo.find_by_openid(openid) || UserRepo.build_by_openid(openid)

      user.valid? # fill up user#errors

      user
    end

    private 

    def registrator
      Registrator.new(app)
    end
  end
end