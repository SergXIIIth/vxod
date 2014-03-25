class Vxod::Config
  def initialize
    @login_path = '/login'
  end

  attr_accessor :login_path, :secret_secret
end