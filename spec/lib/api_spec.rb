require 'spec_helper'

describe Vxod::Api do
  let(:rack_app){ double('rack_app') }
  let(:vxod){ Vxod::Api.new(rack_app) }

  before do
    allow(rack_app).to receive(:request){ double(path: '/') }
  end

  describe '#required' do
    context 'when not authorized' do
      it 'redirects to login path' do
        expect(rack_app).to receive(:redirect).with{ |path|
          path.should start_with(Vxod.config.login_path)
        }
        
        vxod.required
      end

      it 'keeps back path' do
        back_path = '/secret_page'
        allow(rack_app).to receive(:request){ double(path: back_path) }

        expect(rack_app).to receive(:redirect).with{ |path|
          path.should end_with("?back=#{back_path}")
        }

        vxod.required
      end
    end
  end
end