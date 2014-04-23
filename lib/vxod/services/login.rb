module Vxod
  class Login
    def initialize(app)
      @app = app
    end

    def login
      user = Db.user.find_by_email(login_form.email)

      if user
        check_lock(user)
      else
        error
      end
    end

private

    attr_reader :app

    def check_lock(user)
      if user.lock_code.blank?
        check_password(user)
      else
        error_lock
      end
    end

    def check_password(user)
      if BCrypt::Password.new(user.password_hash) == login_form.password
        authentify(user)
      else
        error
      end
    end

    def authentify(user)
      app.authentify_and_back(user, login_form.remember_me)
      login_form
    end

    def login_form
      @login_form ||= LoginForm.init_by_params(app.params)
    end

    def error
      login_form.errors[''] = 'Email or password invalid'
      login_form
    end

    def error_lock
      login_form.errors[''] = 'Account is lock. Please contact the support'
      login_form
    end
  end
end