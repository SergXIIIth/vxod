# Responsibility - have one API for all frameworks
# Wrap on Rack frameworks (Sinatra, Rails ...)
class Vxod::RackAppWrap
  def initialize(rack_app)
    @rack_app = rack_app
  end

  attr_reader :rack_app

  def redirect(url)
    rack_app.redirect(url)
  end

  def request_path
    rack_app.request.path
  end
end