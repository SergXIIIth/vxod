module Vxod
  class Config
    def initialize
      @login_path = '/login'
      @registration_path = '/registration'
      @logout_path = '/logout'
      @fill_openid_path = '/fill_openid'
      @after_login_default_path = '/'
      @confirm_email_path = '/confirm_email_path'
    end

    attr_accessor \
      :login_path,
      :logout_path,
      :confirm_email_path,
      :fill_openid_path,
      :after_login_default_path,
      :registration_path
  end
end
