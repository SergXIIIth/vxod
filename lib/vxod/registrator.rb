module Vxod
  class Registrator
    def initialize(app)
      @app = app
    end

    attr_reader :app

    def register
      user = User.register(app.params)
     
      # Notify.registration(user, auto_password) if user.valid?

      user
    end
  end
end