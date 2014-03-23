require 'spec_helper'

describe Vxod do
  describe '.api' do
    it 'init rack_app' do
      rack_app = Object.new
      vxod = Vxod.api(rack_app)

      vxod.rack_app.should == rack_app
    end
  end
end