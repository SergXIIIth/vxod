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

    def save_user_data
      if Email.valid?(app.params['email'])
        user = Db.user.find_by_auth_key(app.auth_key_for_fill_user_data)
        user.email      = app.params['email']
        user.firstname  = app.params['firstname']
        user.lastname   = app.params['lastname']
        user.save!

        app.authentify_and_back(user)
      else
        false
      end
    end
  end
end