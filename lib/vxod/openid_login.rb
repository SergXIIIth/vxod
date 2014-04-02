module Vxod
  class OpenidLogin
    def initialize(app)
      @app = app
    end

    attr_reader :app

    def login
      openid = OpenidRepo.find_or_create(app.omniauth_hash)
      user = UserRepo.find_or_create_by_openid(openid)
        
      if user.valid?
        app.authentify_and_back(user)
      else
        app.redirect_to_fill_openid(openid)
      end
    end

    def update_openid_data
      openid = app.current_openid
      user = UserRepo.create_by_openid(openid, app.params)

      if user.valid?
        app.authentify_and_back(user)
      end

      user
    end

    def show_openid_data
      openid = app.current_openid
      user = UserRepo.find_or_create_by_openid(openid)

      if user.valid?
        app.authentify_and_back(user)
      end

      user
    end
  end
end