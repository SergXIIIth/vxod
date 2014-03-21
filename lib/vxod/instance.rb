class Vxod::Instance
  def initialize(rack_app)
    @rack_app = rack_app
  end

  attr_reader :rack_app

  def authorize
    rack_app_wrap.redirect('/path')
  end

private

  def rack_app_wrap
    @rack_app_wrap ||= Vxod::RackAppWrap.new(rack_app)
  end
end