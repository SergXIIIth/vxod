class ResetPasswordForm
  def initialize
    @errors = {}
  end

  attr_accessor :email

  attr_reader :errors

  class << self
    def init_by_params(params)
      ResetPasswordForm.new.tap do |reset_password_form|
        login_form.email = params['email']
      end
    end
  end
end
