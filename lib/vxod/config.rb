module Vxod
  class Config
    def initialize
      @login_path = '/login'
      @registration_path = '/registration'
      @logout_path = '/logout'
      @fill_user_data_path = '/fill_user_data'
      @after_login_default_path = '/'
    end

    attr_accessor :login_path, 
      :logout_path, 
      :fill_user_data_path, 
      :after_login_default_path,
      :registration_path
  end
end