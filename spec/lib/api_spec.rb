require 'spec_helper'

module Vxod
  describe Api do
    let(:rack_app){ double('rack_app') }
    let(:vxod){ Api.new(rack_app) }


    describe '#required' do
      before do
        allow(rack_app).to receive(:request){ double(path: '/') }
        allow(vxod).to receive(:user){ nil }
      end

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

      context 'when authorized' do
        let(:user){ double('user') }

        before do
          allow(vxod).to receive(:user){ user }
        end

        it 'true' do
          expect(vxod.required).to be_true
        end
      end
    end
  end
end