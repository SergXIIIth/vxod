require 'spec_helper'
require 'vxod/db/mongoid'

module Vxod
  describe UserRepo do
    let(:user){ double('user') }
    let(:firstname){ double('firstname') }
    let(:lastname){ double('lastname') }
    let(:email){ double('email') }
    let(:openid){ double('openid') }
    let(:password){ double('password') }
    let(:secure_random){ double('secure_random') }
    let(:params){{ 'firstname' => firstname, 'lastname' => lastname, 'email' => email }}

    before do
      allow(Db).to receive(:user){ double(new: user) }
      allow(user).to receive(:new){ user }
    end

    describe '.create' do
      before do
        params.merge!({'password' => password, 'auto_password' => false})
        allow(UserRepo).to receive(:create_with_password){ user }
        allow(UserRepo).to receive(:build){ user }
      end

      after{ UserRepo.create(params) }

      it 'validate password when not auto password'

      it 'call build' do
        expect(UserRepo).to receive(:build).with(firstname, lastname, email)
      end

      it 'call create_with_password' do
        expect(UserRepo).to receive(:create_with_password).with(user, password)
      end

      it 'returns user' do
        expect(UserRepo.create(params)).to eq user
      end
    end

    describe '.create_by_openid' do
      before do
        allow(UserRepo).to receive(:build_by_openid).with(openid){ user }
        allow(UserRepo).to receive(:create_with_password){ user }
      end

      subject(:create_by_openid){ UserRepo.create_by_openid(openid, password) }

      it 'invoke build_by_openid' do
        expect(UserRepo).to receive(:build_by_openid).with(openid){ user }
        create_by_openid
      end

      it 'call create_with_password' do
        expect(UserRepo).to receive(:create_with_password).with(user, password)
        create_by_openid
      end

      it 'returns user' do
        expect(create_by_openid).to eq user
      end
    end

    describe '.create_by_clarify_openid' do
      after{ UserRepo.create_by_clarify_openid(openid, params) }

      it 'delegates to create' do
        expect(UserRepo).to receive(:create).with(params)
      end
    end

    describe '.build_by_openid' do
      let(:raw){ double('raw') }
      let(:parser){ double('parser') }

      before do
        allow(openid).to receive(:raw){ raw }
        allow(UserRepo).to receive(:build){ user }

        allow(OpenidRawParser).to receive(:new){ parser }
        allow(parser).to receive(:firstname){ firstname }
        allow(parser).to receive(:lastname){ lastname }
        allow(parser).to receive(:email){ email }
      end

      after{ UserRepo.build_by_openid(openid) }

      it 'send openid#raw to parser' do
        expect(OpenidRawParser).to receive(:new).with(raw)
      end

      it 'invoke build base on parsed data' do
        expect(UserRepo).to receive(:build).with(firstname, lastname, email)
      end
    end

    describe '.build' do
      before do
        allow(user).to receive(:auth_key=)
        allow(user).to receive(:firstname=)
        allow(user).to receive(:lastname=)
        allow(user).to receive(:email=)
        allow(user).to receive(:confirm_email_key=)
        allow(user).to receive(:auth_key=)
        allow(SecureRandom).to receive(:base64).with(64)
        allow(SecureRandom).to receive(:hex).with(20)
      end

      subject(:build){ UserRepo.send(:build, firstname, lastname, email) }

      it 'set fields' do
        expect(user).to receive(:firstname=).with(firstname)
        expect(user).to receive(:lastname=).with(lastname)
        expect(user).to receive(:email=).with(email)

        build
      end

      it 'generate auth_key' do
        allow(SecureRandom).to receive(:base64).with(64){ secure_random }

        expect(user).to receive(:auth_key=).with(secure_random)

        build
      end

      it 'generate User#confirm_email_key' do
        allow(SecureRandom).to receive(:hex).with(20){ secure_random }

        expect(user).to receive(:confirm_email_key=).with(secure_random)

        build
      end
    end

    describe '.create_with_password' do
      subject(:create_with_password){ UserRepo.send(:create_with_password, user, password) }

      before do
        allow(user).to receive(:password_valid?){ false }
      end

      it 'validates password' do
        expect(user).to receive(:password_valid?).with(password)
        create_with_password
      end

      it 'return user' do
        expect(create_with_password).to eq user
      end

      context 'when pasword valid' do
        let(:password_hash){ double('password_hash') }

        before do
          allow(user).to receive(:password_valid?){ true }
          allow(user).to receive(:password_hash=)
          allow(BCrypt::Password).to receive(:create){ password_hash }
          allow(user).to receive(:save)
        end

        it 'crypt password' do
          expect(BCrypt::Password).to receive(:create).with(password)
          create_with_password
        end

        it 'store password in password_hash' do
          expect(user).to receive(:password_hash=).with(password_hash)
          create_with_password
        end

        it 'save user' do
          expect(user).to receive(:save)
          create_with_password
        end
      end
    end
  end
end