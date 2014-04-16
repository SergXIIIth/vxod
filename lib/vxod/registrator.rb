module Vxod
  class Registrator
    def initialize(app)
      @app = app
    end

    attr_reader :app

    def register
      user = UserRepo.create(params)
     
      if user.valid?
        Notify.new.registration(user, password, app.request_host) 
        app.authentify_and_back(user)
      end
      
      user
    end

    def register_by_openid(openid)
      user = UserRepo.create_by_openid(openid, generate_password)
        
      if user.valid?
        openid_registered(openid, user)
      else
        app.redirect_to_fill_openid(openid)
      end
    end

    def register_by_clarify_openid(openid)
      params['password'] = generate_password
      user = UserRepo.create_by_clarify_openid(openid, params)
      openid_registered(openid, user)
    end

    private

    def params
      unless @params
        @params = app.params.clone
        @params['password'] = password
      end
      @params
    end

    def generate_password
      @password = SecureRandom.hex(4)
    end

    def password
      @password ||= if app.params['auto_password'] == 'on'
        generate_password
      else
        app.params['password']
      end
    end

    def openid_registered(openid, user)
      if user.valid?
        openid.user = user
        openid.save!

        Notify.new.openid_registration(openid, password, app.request_host)
        app.authentify_and_back(user)
      end

      user
    end
  end
end