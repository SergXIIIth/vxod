require 'spec_helper'

module Vxod
  describe Api do
    let(:rack_app){ double('rack_app') }
    let(:vxod){ Api.new(rack_app) }


    describe '#required' do
      let(:back_path){ "/secret_page#{rnd}" }
      let(:session){ {} }

      before do
        allow(rack_app).to receive(:request){ double(path: back_path) }
        allow(vxod).to receive(:user){ nil }
        allow(rack_app).to receive(:redirect)
        allow(rack_app).to receive(:session){ session }
      end

      context 'when not authorized' do
        it 'redirects to login path' do
          expect(rack_app).to receive(:redirect).with(Vxod.config.login_path)
          vxod.required
        end

        it 'save back path in session' do
          vxod.required
          expect(session['vxod.back_path']).to eq back_path
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