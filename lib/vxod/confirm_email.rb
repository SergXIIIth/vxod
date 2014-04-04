module Vxod
  class ConfirmEmail
    def initialize(app)
      @app = app
    end

    attr_reader :app

    # input app.params
    #   key -> User#confirm_email_key
    #   lock -> any value
    # return
    #   { success: false/true, error: ["1", "2"] }
    def confirm
      user = Db.user.find_by_confirm_email_key(app.params['key'])

      if user
        if user.confirm_at
          { success: false, error: [ "Email already confirmed" ] }
        else
          user.confirm_at = DateTime.now
          user.save!
          { success: true }
        end
      else
        fail "Confirmation link with bad key - #{app.request_path}"
      end
    end
  end
end