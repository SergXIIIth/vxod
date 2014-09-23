module Vxod
  class OpenidLogin
    def initialize(app)
      @app = app
    end

    attr_reader :app

    def login
      openid = OpenidRepo.find_or_create(app.omniauth_hash)

      login_form = LoginForm.new

      if openid.user
        if openid.user.lock_code
          login_form.errors['lock'] = I18n.t('vxod.errors.lock')
        else
          app.authentify_and_back(openid.user)
        end
      else
        registrator.register_by_openid(openid)
      end

      login_form
    end

    def update_openid_data
      registrator.register_by_clarify_openid(app.current_openid)
    end

    def show_openid_data
      openid = app.current_openid

      user = openid.user || UserRepo.build_by_openid(openid)
      user.valid?
      user
    end

    private

    def registrator
      Registrator.new(app)
    end
  end
end
