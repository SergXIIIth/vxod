class LoginForm
  def initialize
    @errors = {}
  end

  attr_accessor :email,
                :password,
                :remember_me
  
  # hash - {field_name: "error description"}
  attr_reader :errors

  def errors?
    errors.any?
  end

  class << self
    def init_by_params(params)
      LoginForm.new.tap do |login_form|
        login_form.email = params['email']
        login_form.password = params['password']
        login_form.remember_me = params['remember_me']
      end
    end
  end
end