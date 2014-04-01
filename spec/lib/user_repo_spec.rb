require 'spec_helper'
require 'vxod/db/mongoid'

module Vxod
  describe UserRepo do
    let(:user){ double('user') }
    let(:firstname){ rnd('firstname') }
    let(:lastname){ rnd('lastname') }
    let(:secure_random){ rnd('secure_random') }
    let(:email){ "sergey#{rnd}@makridenkov.com" }

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
        allow(user).to receive(:firstname=)
        allow(user).to receive(:lastname=)
        allow(user).to receive(:email=)
        allow(user).to receive(:password=).with(password)
        allow(user).to receive(:auth_key=)
        allow(user).to receive(:save)
      end

      it 'set fields' do
        expect(user).to receive(:firstname=).with(firstname)
        expect(user).to receive(:lastname=).with(lastname)
        expect(user).to receive(:email=).with(email)
        expect(user).to receive(:password=).with(password)

        UserRepo.register(params)
      end

      it 'gerenate password when auto password' do
        params['auto_password'] = true
        allow(SecureRandom).to receive(:hex).with(4){ secure_random }

        expect(user).to receive(:password=).with(secure_random)

        UserRepo.register(params)
      end

      it 'generate auth_key' do
        allow(SecureRandom).to receive(:base64).with(64){ secure_random }

        expect(user).to receive(:auth_key=).with(secure_random)

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

    describe '.create_from_openid' do
      it 'create user'
    end
  end
end