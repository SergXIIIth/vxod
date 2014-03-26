require 'spec_helper'

module Vxod
  describe App do
    let(:response){ double('response') }
    let(:request){ double('request') }
    let(:rack_app){ double('rack_app', response: response, request: request) }
    let(:app){ App.new(rack_app) }

    describe '#after_login_path' do
      it 'take back path from url param'
      it 'return default back path when no present in url'
    end

    describe '#authentify' do
      it 'set cookie with for whole domain with 10 years expires' do
        auth_key = rnd('auth_key')
        host = rnd('host')
        allow(request).to receive(:host){ host }

        expect(response).to receive(:set_cookie).with('vxod.auth',
          value: auth_key,
          domain: host,
          path: '/',
          expires: Date.new(DateTime.now.year + 10, 1, 1)
        )

        app.authentify(auth_key)
      end
    end

    describe '#authentify_for_fill_user_data' do
      it 'set cookie for fill user data only' do
        auth_key = rnd('auth_key')
        host = rnd('host')
        allow(request).to receive(:host){ host }

        expect(response).to receive(:set_cookie).with('vxod.auth_fill_user_data',
          value: auth_key,
          domain: host,
          path: Vxod.config.fill_user_data_path
        )

        app.authentify_for_fill_user_data(auth_key)
      end
    end
  end
end