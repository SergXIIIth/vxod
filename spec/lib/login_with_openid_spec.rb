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
    let(:login_with_openid){ LoginWithOpenid.new(app) }

    before do
      allow(user).to receive(:auth_key){ auth_key }
    end

    describe '#login' do
      before do
        allow(Db).to receive(:identity){ identity_class }
        allow(app).to receive(:omniauth_hash){{ uid: openid, provider: provider }}
        allow(identity).to receive(:user){ user }
      end

      context 'when identity exists and user has valid email' do
        before do
          allow(app).to receive(:authentify)
          allow(app).to receive(:redirect_to_after_login)
    
          allow(user).to receive(:email){ 'sergey@makridenkov.com' }
          allow(identity_class).to receive(:find_by_openid).with(provider, openid){ identity }
        end

        it 'authentify' do
          expect(app).to receive(:authentify).with(auth_key)
          login_with_openid.login
        end

        it 'redirect back' do
          expect(app).to receive(:redirect_to_after_login)
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

          allow(User).to receive(:create_openid){ user }

          omniauth_info = { email: email, first_name: firstname, last_name: lastname }
          allow(app).to receive(:omniauth_hash){{ uid: openid, provider: provider, info: omniauth_info }}
          allow(app).to receive(:authentify)
          allow(app).to receive(:redirect_to_after_login)
        end

        it 'create identity' do
          expect(User).to receive(:create_openid).with(provider, openid, email, firstname, lastname){ user }
          login_with_openid.login
        end

        it 'authentify' do
          expect(app).to receive(:authentify).with(auth_key)
          login_with_openid.login
        end

        it 'redirect user back' do
          expect(app).to receive(:redirect_to_after_login)
          login_with_openid.login
        end
      end

      context 'when user have not valid email' do
        before do 
          allow(user).to receive(:email){ 'invalid_email' }
          allow(identity_class).to receive(:find_by_openid).with(provider, openid){ identity }

          allow(app).to receive(:authentify_for_fill_user_data)
          allow(app).to receive(:redirect)
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

    describe 'save_user_data' do
      let(:firstname){ rnd('firstname') }
      let(:lastname){ rnd('lastname') }
      let(:params){{ 'firstname' => firstname, 'lastname' => lastname }}

      before do
        allow(app).to receive(:params){ params }
      end

      context 'when email invalid' do
        it 'false' do
          params['email'] = 'invalid_email'
          expect(login_with_openid.save_user_data).to be_false
        end
      end

      context 'when email valid' do
        let(:email){ "sergey#{rnd}@makridenkov.com" }

        before do
          params['email'] = email

          allow(app).to receive(:authentify)
          allow(app).to receive(:redirect_to_after_login)
          allow(app).to receive(:auth_key_for_fill_user_data){ auth_key }

          user_class = double('user_class')
          allow(user_class).to receive(:find_by_auth_key).with(auth_key){ user }

          allow(Db).to receive(:user){ user_class }

          allow(user).to receive(:email=)
          allow(user).to receive(:firstname=)
          allow(user).to receive(:lastname=)
          allow(user).to receive(:save!)
        end

        it 'save user date' do
          expect(user).to receive(:email=).with(email)
          expect(user).to receive(:firstname=).with(firstname)
          expect(user).to receive(:lastname=).with(lastname)
          expect(user).to receive(:save!)

          login_with_openid.save_user_data
        end

        it 'authentify' do
          expect(app).to receive(:authentify).with(auth_key)
          login_with_openid.save_user_data
        end

        it 'redirect back' do
          expect(app).to receive(:redirect_to_after_login)
          login_with_openid.save_user_data
        end
      end
    end
  end
end