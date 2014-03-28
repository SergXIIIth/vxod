require 'spec_helper'

module Vxod
  describe BackPath do
    let(:params){ {} }
    let(:back_url){ rnd('back_url') }
    let(:rack_app){ double('rack_app', params: params) }
    let(:back_path){ BackPath.new(rack_app) }

    describe '#get' do
      it 'take back path from session' do
        fail
        params['back'] = back_url
        expect(back_path.get).to eq back_url
      end

      it 'return default back path when no present in session' do
        expect(back_path.get).to eq Vxod.config.after_login_default_path
      end
    end
  end
end