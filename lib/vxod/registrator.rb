module Vxod
  class Registrator
    def initialize(app)
      @app = app
    end

    attr_reader :app

    def register
      params = app.params.clone
      params['auto_password'] = app.params['auto_password'] == 'on'

      user = UserRepo.register(params)
     
      if user.valid?
        Notify.new.registration(user, app.request_host, params['auto_password']) 
        app.authentify_and_back(user)
      end
      
      user
    end

    def register_by_openid(openid)
      user = UserRepo.create_by_openid(openid)
        
      if user.valid?
        openid_registered(openid, user)
      else
        app.redirect_to_fill_openid(openid)
      end
    end

    def register_by_clarify_openid(openid)
      user = UserRepo.create_by_clarify_openid(openid, app.params)
      openid_registered(openid, user)
    end

    private

    def openid_registered(openid, user)
      if user.valid?
        openid.user = user
        openid.save!

        Notify.new.openid_registration(openid, app.request_host)
        app.authentify_and_back(user)
      end

      user
    end
  end
end