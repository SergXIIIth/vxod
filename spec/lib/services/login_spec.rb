require 'spec_helper'

module Vxod
  describe Login do
    let(:app){ double('app') }
    let(:params){ double('params') }
    let(:user){ double('user') }
    let(:login_obj){ Login.new(app) }
    let(:result){ double('result') }

    before do
      allow(app).to receive(:params){ params }
    end

    describe '#login' do
      let(:email){ double('email') }

      before do
        allow(params).to receive(:[]).with('email'){ email }
        allow(Db.user).to receive(:find_by_email){ nil }
      end

      after { login_obj.login }

      it 'search user by email' do
        expect(Db.user).to receive(:find_by_email).with(email){ nil }
      end

      context 'when user not found by email' do
        it 'return an error' do
          expect(login_obj.login.success?).to be_false
        end
      end

      context 'when user found' do
        before do
          allow(Db.user).to receive(:find_by_email){ user }
          allow(login_obj).to receive(:check_password){ result }
        end

        it 'delegate to #check_password' do
          expect(login_obj).to receive(:check_password).with(user)
        end

        it 'returns #check_password result' do
          expect(login_obj.login).to eq result
        end
      end
    end

    describe '#check_password' do
      let(:crypt){ double('crypt') }
      let(:password){ double('password') }
      let(:password_hash){ double('password_hash') }

      before do
        allow(BCrypt::Password).to receive(:new).with(password_hash){ crypt }
        allow(crypt).to receive(:==).with(password){ false }
        allow(user).to receive(:password_hash){ password_hash }
        allow(params).to receive(:[]).with('password'){ password }
      end

      subject(:check_password){ login_obj.check_password(user) }

      it 'check password' do
        expect(BCrypt::Password).to receive(:new).with(password_hash){ crypt }
        expect(crypt).to receive(:==).with(password)
        check_password
      end

      context 'when password match' do
        before do
          allow(crypt).to receive(:==).with(password){ true }
        end

        it 'delegate to #authentify' do
          expect(login_obj).to receive(:authentify).with(user){ result }
          expect(check_password).to eq result
        end
      end

      context 'when password do not match' do
        it 'return an error' do
          expect(login_obj.check_password(user).success?).to be_false
          check_password
        end
      end
    end

    describe '#authentify' do
      subject(:authentify){ login_obj.authentify(user) }

      before do
        allow(params).to receive(:[]).with('remember_me'){ nil }
        allow(app).to receive(:authentify_and_back)
      end        
      
      it 'returns success' do
        expect(authentify.success?).to be_true
      end

      context 'when remember me' do
        before do
          allow(params).to receive(:[]).with('remember_me'){ 'on' }
        end

        it 'authentify and redirect back' do
          expect(app).to receive(:authentify_and_back).with(user, true)
          authentify
        end
      end

      context 'when do not remember me' do
        it 'authentify by session cookie and redirect back' do
          expect(app).to receive(:authentify_and_back).with(user, false)
          authentify
        end
      end
    end
  end
end