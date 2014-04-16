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

    describe '.crypt_password' do
      let(:password_hash){ double('password_hash') }

      it 'set User#password_hash' do
        expect(BCrypt::Password).to receive(:create).with(password){ password_hash }
        expect(user).to receive(:password_hash=).with(password_hash)
        UserRepo.crypt_password(user, password)
      end
    end

    describe '.create' do
      before do
        params.merge!({'password' => password, 'auto_password' => false})
        allow(user).to receive(:save)
        allow(UserRepo).to receive(:crypt_password)
        allow(UserRepo).to receive(:build){ user }
      end

      after{ UserRepo.create(params) }

      it 'validate password when not auto password'

      it 'call build' do
        expect(UserRepo).to receive(:build).with(firstname, lastname, email)
      end

      it 'crypt password' do
        expect(UserRepo).to receive(:crypt_password).with(user, password)
      end

      it 'save to db' do
        expect(user).to receive(:save)
      end

      it 'returns user' do
        expect(UserRepo.create(params)).to eq user
      end
    end

    describe '.create_by_openid' do
      before do
        allow(user).to receive(:save)
        allow(user).to receive(:password=)
        allow(UserRepo).to receive(:build_by_openid).with(openid){ user }
        allow(UserRepo).to receive(:crypt_password)
      end

      subject(:create_by_openid){ UserRepo.create_by_openid(openid, password) }

      after{ create_by_openid }

      it 'invoke build_by_openid' do
        expect(UserRepo).to receive(:build_by_openid).with(openid){ user }
      end

      it 'crypt password' do
        expect(UserRepo).to receive(:crypt_password).with(user, password)
      end

      it 'save to DB' do
        expect(user).to receive(:save)
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

      it 'set fields' do
        expect(user).to receive(:firstname=).with(firstname)
        expect(user).to receive(:lastname=).with(lastname)
        expect(user).to receive(:email=).with(email)

        UserRepo.build(firstname, lastname, email)
      end

      it 'generate auth_key' do
        allow(SecureRandom).to receive(:base64).with(64){ secure_random }

        expect(user).to receive(:auth_key=).with(secure_random)

        UserRepo.build(firstname, lastname, email)
      end

      it 'generate User#confirm_email_key' do
        allow(SecureRandom).to receive(:hex).with(20){ secure_random }

        expect(user).to receive(:confirm_email_key=).with(secure_random)

        UserRepo.build(firstname, lastname, email)
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
  end
end