require 'spec_helper'

module Vxod
  describe Api do
    let(:rack_app){ double('rack_app') }
    let(:vxod){ Api.new(rack_app) }

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

    describe '#login_with_openid' do
      it 'authentify user when identity exists' do
      end

      it 'redirect user back when user have email'
  
      context 'when identity not found' do
        it 'create identity'
        it 'create user'
        it 'redirect user back'
      end

      context 'when user have not email' do
        it 'authentify temporary'
        it 'redirect user to fill email page'
      end
    end
  end
end