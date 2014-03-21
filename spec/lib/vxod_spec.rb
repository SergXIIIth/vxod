require 'spec_helper'

describe Vxod do
  describe '.new_instance' do
    it 'init rack_app' do
      rack_app = Object.new
      vxod = Vxod.new_instance(rack_app)

      vxod.rack_app.should == rack_app
    end
  end
end