require 'spec_helper'

module Vxod
  describe App do
    let(:response){ double('response') }
    let(:request){ double('request') }
    let(:rack_app){ double('rack_app', response: response, request: request) }
    let(:app){ App.new(rack_app) }

    describe '#authentify' do
      it 'set cookie with for whole domain with 10 years expires' do
        auth_key = rnd('auth_key')
        host = rnd('host')
        allow(request).to receive(:host){ host }

        expect(response).to receive(:set_cookie).with('vxod.auth',
          value: auth_key,
          path: '/',
          expires: Time.new(DateTime.now.year + 10, 1, 1),
          httponly: true
        )

        app.authentify(auth_key)
      end
    end

    describe '#redirect_fill_openid' do
      it 'store openid#id in session["vxod.openid"]'
    end

    describe '#authentify_and_back' do
      it 'authentify and redirect to after login path'
    end

    describe '#authentify_for_fill_user_data' do
      it 'set cookie for fill user data only' do
        auth_key = rnd('auth_key')
        host = rnd('host')
        allow(request).to receive(:host){ host }

        expect(response).to receive(:set_cookie).with('vxod.auth_fill_user_data',
          value: auth_key,
          path: Vxod.config.fill_user_data_path,
          httponly: true
        )

        app.authentify_for_fill_user_data(auth_key)
      end
    end
  end
end