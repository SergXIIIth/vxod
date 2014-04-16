module Vxod
  class Login
    def initialize(app)
      @app = app
    end

    attr_reader :app

    def login
      user = Db.user.find_by_email(app.params['email'])

      if user
        check_password(user)
      else
        error
      end
    end

    def check_password(user)
      if BCrypt::Password.new(user.password_hash) == app.params['password']
        authentify(user)
      else
        error
      end
    end

    def authentify(user)
      remember_me = app.params['remember_me'] == 'on'
      app.authentify_and_back(user, remember_me)
      Success.new
    end

    private

    def error
      Error.new('Email or password invalid')
    end
  end
end