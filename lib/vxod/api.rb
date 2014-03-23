class Vxod::Api
  def initialize(rack_app)
    @rack_app = rack_app
  end

  attr_reader :rack_app

  # Check that user login and have right to make 'action' on 'object'
  # If not it redirects to login page
  def required(action = nil, object = nil)
    path = "#{Vxod.config.login_path}?back=#{URI.escape(rack_app_wrap.request_path)}"
    rack_app_wrap.redirect(path)
  end

private

  def rack_app_wrap
    @rack_app_wrap ||= Vxod::RackAppWrap.new(rack_app)
  end
end