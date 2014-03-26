require 'spec_helper'

module Vxod
  describe LoginWithOpenid do
    let(:app){ double('app') }
    let(:identity){ double('identity') }
    let(:user){ double('user') }
    let(:identity_class){ double('identity_class') }
    let(:provider){ rnd('provider') }
    let(:openid){ rnd('openid') }
    let(:auth_key){ rnd('auth_key') }
    let(:after_login_path){ rnd('after_login_path') }
    let(:login_with_openid){ LoginWithOpenid.new(app) }

    before do
      allow(app).to receive(:omniauth_hash){{ uid: openid, provider: provider }}
      allow(app).to receive(:after_login_path){ after_login_path }
      allow(app).to receive(:redirect)

      allow(Db).to receive(:identity){ identity_class }
      allow(identity).to receive(:user){ user }

      allow(user).to receive(:auth_key){ auth_key }
    end

    describe '#login' do
      context 'when identity exists and user has valid email' do
        before do
          allow(app).to receive(:authentify)
          allow(app).to receive(:redirect)
    
          allow(user).to receive(:email){ 'sergey@makridenkov.com' }
          allow(identity_class).to receive(:find_by_openid).with(provider, openid){ identity }
        end

        it 'authentify' do
          expect(app).to receive(:authentify).with(auth_key)
          login_with_openid.login
        end

        it 'redirect back' do
          expect(app).to receive(:redirect).with(after_login_path)
          login_with_openid.login
        end
      end
  
      context 'when identity not found' do
        let(:email){ rnd('email') }
        let(:firstname){ rnd('firstname') }
        let(:lastname){ rnd('lastname') }

        before do
          allow(user).to receive(:email){ 'sergey@makridenkov.com' }
          allow(identity_class).to receive(:find_by_openid).with(provider, openid){ nil }

          allow(Db).to receive(:identity_create){ identity }

          omniauth_info = { email: email, first_name: firstname, last_name: lastname }
          allow(app).to receive(:omniauth_hash){{ uid: openid, provider: provider, info: omniauth_info }}
          allow(app).to receive(:authentify)
        end

        it 'create identity' do
          expect(Db).to receive(:identity_create).with(provider, openid, email, firstname, lastname){ identity }
          login_with_openid.login
        end

        it 'authentify' do
          expect(app).to receive(:authentify).with(auth_key)
          login_with_openid.login
        end

        it 'redirect user back' do
          expect(app).to receive(:redirect).with(after_login_path)
          login_with_openid.login
        end
      end

      context 'when user have not valid email' do
        before do 
          allow(user).to receive(:email){ 'invalid_email' }
          allow(identity_class).to receive(:find_by_openid).with(provider, openid){ identity }
          allow(app).to receive(:authentify_for_fill_user_data)
        end

        it 'authentify for fill user data' do
          expect(app).to receive(:authentify_for_fill_user_data).with(auth_key)
          login_with_openid.login
        end

        it 'redirect user to fill email page' do
          expect(app).to receive(:redirect).with(Vxod.config.fill_user_data_path)
          login_with_openid.login
        end
      end
    end
  end
end