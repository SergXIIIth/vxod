require 'spec_helper'
require 'vxod/db/mongoid'

module Vxod
  describe UserRepo do
    let(:user){ double('user') }
    let(:firstname){ rnd('firstname') }
    let(:lastname){ rnd('lastname') }
    let(:email){ "sergey#{rnd}@makridenkov.com" }
    let(:secure_random){ double('secure_random') }
    let(:params){{ 'firstname' => firstname, 'lastname' => lastname, 'email' => email }}
    let(:openid){ double('openid') }

    before do
      allow(Db).to receive(:user){ double(new: user) }
      allow(user).to receive(:new){ user }
    end

    describe '.register' do
      let(:password){ rnd('password') }
      let(:params){{
        'firstname' => firstname, 
        'lastname' => lastname, 
        'email' => email, 
        'password' => password,
        'auto_password' => false
      }}

      before do
        allow(user).to receive(:password=)
        allow(user).to receive(:save)
        allow(UserRepo).to receive(:build){ user }
      end

      it 'generate password if params["password"] missing'

      it 'call build' do
        expect(UserRepo).to receive(:build).with(firstname, lastname, email)

        UserRepo.register(params)
      end

      it 'set password' do
        expect(user).to receive(:password=).with(password)

        UserRepo.register(params)
      end

      it 'gerenate password when auto password' do
        params['auto_password'] = true
        allow(SecureRandom).to receive(:hex).with(4){ secure_random }

        expect(user).to receive(:password=).with(secure_random)

        UserRepo.register(params)
      end

      it 'save to db' do
        expect(user).to receive(:save)
        UserRepo.register(params)
      end

      it 'returns user' do
        expect(UserRepo.register(params)).to eq user
      end
    end

    describe '.create_by_openid' do
      before do
        allow(user).to receive(:save)
        allow(UserRepo).to receive(:build_by_openid).with(openid){ user }
      end

      after{ UserRepo.create_by_openid(openid) }

      it 'invoke build_by_openid' do
        expect(UserRepo).to receive(:build_by_openid).with(openid){ user }
      end

      it 'save to db' do
        expect(user).to receive(:save)
      end

      it 'returns user' do
        expect(UserRepo.create_by_openid(openid)).to eq user
      end
    end

    describe '.create_by_clarify_openid' do
      it 'take name, surname, email from params'
      it 'create user with auto password'
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
      it 'initialize user from openid#raw'
    end
  end
end