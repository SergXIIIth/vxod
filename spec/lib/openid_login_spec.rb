require 'spec_helper'

module Vxod
  describe OpenidLogin do
    let(:app){ double('app') }
    let(:user){ double('user') }
    let(:openid_login){ OpenidLogin.new(app) }

    before do
      allow(app).to receive(:authentify_and_back)
    end

    describe '#login' do
      let(:openid){ double('openid') }
      let(:omniauth_hash){ double('omniauth_hash') }
  
      before do
        allow(app).to receive(:omniauth_hash){ omniauth_hash }
        allow(OpenidRepo).to receive(:find_or_create){ openid }
        allow(UserRepo).to receive(:find_or_create_by_openid){ user }
        allow(user).to receive('valid?'){ true }
      end

      it 'find or create openid' do
        expect(OpenidRepo).to receive(:find_or_create).with(omniauth_hash)
        openid_login.login
      end

      it 'find or create user by openid' do
        expect(UserRepo).to receive(:find_or_create_by_openid).with(openid)
        openid_login.login
      end

      it 'authentify and redirect back when user valid' do
        expect(app).to receive(:authentify_and_back).with(user)
        openid_login.login
      end 

      it 'redirect to fill openid page when user invalid' do
        allow(user).to receive('valid?'){ false }
        expect(app).to receive(:redirect_to_fill_openid).with(openid)
        openid_login.login
      end
    end

    describe '#save_user_data' do
      let(:auth_key){ rnd('auth_key') }
      let(:firstname){ rnd('firstname') }
      let(:lastname){ rnd('lastname') }
      let(:params){{ 'firstname' => firstname, 'lastname' => lastname }}

      before do
        allow(app).to receive(:params){ params }
        allow(user).to receive(:auth_key){ auth_key }
      end

      context 'when email invalid' do
        it 'false' do
          params['email'] = 'invalid_email'
          expect(openid_login.save_user_data).to be_false
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

          openid_login.save_user_data
        end

        it 'authentify and redirect back' do
          expect(app).to receive(:authentify_and_back).with(user)
          openid_login.save_user_data
        end
      end
    end
  end
end