module Vxod
  class Login
    def initialize(app)
      @app = app
    end

    attr_reader :app

    def login
      user = Db.user.find_by_email(app.params['email'])
      
      if user
        login_with_user(user)
      else
        Error.new('Email or password invalid')
      end
    end

    def login_with_user(user)
    end

    def authentify(user)
    end
  end
end