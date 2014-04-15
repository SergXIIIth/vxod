require 'spec_helper'

module Vxod
  describe OpenidLogin do
    let(:app){ double('app') }
    let(:user){ double('user') }
    let(:openid){ double('openid') }
    let(:openid_login){ OpenidLogin.new(app) }
    let(:notify){ double('notify') }
    let(:host){ double('host') }

    before do
      allow(app).to receive(:request_host){ host }
      allow(Notify).to receive(:new){ notify }
      allow(user).to receive('valid?'){ false }
    end

    describe '#login', :focus do
      let(:openid){ double('openid') }
      let(:omniauth_hash){ double('omniauth_hash') }

      before do
        allow(app).to receive(:omniauth_hash){ omniauth_hash }
        allow(OpenidRepo).to receive(:find_or_create){ openid }
        allow(UserRepo).to receive(:find_or_create_by_openid){ user }
        allow(app).to receive(:redirect_to_fill_openid).with(openid)
      end

      after { openid_login.login }

      it 'find or create openid' do
        expect(OpenidRepo).to receive(:find_or_create).with(omniauth_hash)
      end

      context 'when user exist' do
        it 'authentify and redirect back'
      end

      context 'when user not exist' do
        it 'register user by openid'
      end
    end

    describe '#update_openid_data' do
      let(:params){ double('params') }

      before do
        allow(app).to receive(:params){ params }
        allow(app).to receive(:current_openid){ openid }
        allow(UserRepo).to receive(:create_by_openid){ user }
      end

      after{ openid_login.update_openid_data }

      it 'try create user by openid' do
        expect(app).to receive(:params){ params }
        expect(app).to receive(:current_openid){ openid }
        expect(UserRepo).to receive(:create_by_openid).with(openid, params)
      end

      it 'openid.user = user when registration success'

      it 'return user' do
        expect(openid_login.update_openid_data).to eq user
      end

      context 'when user valid' do
        before do
          allow(user).to receive('valid?'){ true }
          allow(notify).to receive(:openid_registration)
          allow(app).to receive(:authentify_and_back)
        end
  
        it 'notify user about registration ' do
          expect(notify).to receive(:openid_registration).with(openid, host)
        end

        it 'authentify and redirect back when user valid' do
          expect(app).to receive(:authentify_and_back).with(user)
        end
      end
    end

    describe '#show_openid_data' do
      before do
        allow(app).to receive(:current_openid){ openid }
        allow(UserRepo).to receive(:find_or_create_by_openid){ user }
        allow(user).to receive('valid?'){ false }
      end 

      it 'find user by app.current_openid' do
        expect(app).to receive(:current_openid){ openid }
        expect(UserRepo).to receive(:find_or_create_by_openid).with(openid)

        openid_login.show_openid_data
      end

      it 'authentify when user valid' do
        allow(user).to receive('valid?'){ true }
        expect(app).to receive(:authentify_and_back).with(user)
        openid_login.show_openid_data
      end

      it 'return user' do
        expect(openid_login.show_openid_data).to eq user
      end
    end
  end
end