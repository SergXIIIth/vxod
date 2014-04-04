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
      @user = Db.user.find_by_confirm_email_key(app.params['key'])

      fail "Confirmation link with bad key - #{app.request_path}" if @user.nil?

      if confirm_state.nil?
        update_confirm_state
      else
        confirm_state
      end
    end

    private

    def update_confirm_state
      if app.params['lock']
        @user.lock_code = 'unconfirm_email'
        @user.save!
        { success: false, error: [ "We break registration, if any questions please contact the support" ] }
      else
        @user.confirm_at = DateTime.now
        @user.save!
        { success: true }
      end
    end      

    # nil - state is not set. update allowed
    def confirm_state
      if @user.confirm_at
        { success: false, error: [ "Email already confirmed" ] }
      elsif @user.lock_code
        { success: false, error: [ "We break registration, if any questions please contact the support" ] }
      else
        nil
      end
    end
  end
end