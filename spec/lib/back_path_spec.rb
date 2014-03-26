require 'spec_helper'

module Vxod
  describe BackPath do
    let(:response){ double('response') }
    let(:request){ double('request') }
    let(:rack_app){ double('rack_app', response: response, request: request) }
    let(:app){ App.new(rack_app) }

    describe '#get' do
      it 'take back path from url param'
      it 'return default back path when no present in url'
    end
  end
end