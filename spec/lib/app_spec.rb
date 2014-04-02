require 'spec_helper'

module Vxod
  describe App do
    let(:response){ double('response') }
    let(:request){ double('request') }
    let(:rack_app){ double('rack_app', response: response, request: request) }
    let(:app){ App.new(rack_app) }
    let(:auth_key){ rnd 'auth_key' }

    describe '#authentify' do
      it 'set cookie with for whole domain with 10 years expires' do
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

    describe '#current_openid' do
      it 'return openid by session["vxod.auth_openid"]'
    end

    describe '#redirect_to_fill_openid' do
      let(:session){ {} }
      let(:openid_id){ rnd 'openid_id' }
      let(:openid){ double(id: openid_id) }

      before do
        allow(app).to receive(:session){ session }
        allow(app).to receive(:redirect)
      end

      it 'store openid#id in session["vxod.auth_openid"]' do
        app.redirect_to_fill_openid(openid)
        expect(session['vxod.auth_openid']).to eq openid_id
      end

      it 'redirect fill openid path' do
        expect(app).to receive(:redirect).with(Vxod.config.fill_openid_path)
        app.redirect_to_fill_openid(openid)
      end
    end

    describe '#authentify_and_back' do
      it 'authentify and redirect to after login path' do
        user = double(auth_key: auth_key)

        expect(app).to receive(:authentify).with(auth_key)
        expect(app).to receive(:redirect_to_after_login)

        app.authentify_and_back(user)
      end
    end

  end
end