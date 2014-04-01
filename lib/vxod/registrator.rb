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
        # Notify.registration(user, auto_password) 
        app.authentify(user.auth_key)
        app.redirect_to_after_login
      end
      
      user
    end
  end
end