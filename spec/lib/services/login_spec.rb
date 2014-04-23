require 'spec_helper'

module Vxod
  describe Login do
    let(:app){ double('app') }
    let(:user){ double('user') }
    let(:user_class){ double('User') }
    let(:login_obj){ Login.new(app) }
    let(:result){ double('result') }

    before do
      allow(Db).to receive(:user){ user_class }
    end

    describe '#login_form' do
      let(:params){ double('params') }
  
      before do
        allow(app).to receive(:params){ params }
      end

      subject(:login_form) { Login.new(app).send(:login_form) }

      it 'init LoginForm by app.params' do
        expect(LoginForm).to receive(:init_by_params).with(params)
        login_form
      end
    end

    describe '#login' do
      let(:email){ double('email') }
      let(:login_form){ double('login_form', email: email, errors: {}) }

      before do
        allow(login_obj).to receive(:login_form){ login_form }
        allow(Db.user).to receive(:find_by_email){ nil }
      end

      after { login_obj.login }

      it 'search user by email' do
        expect(Db.user).to receive(:find_by_email).with(email){ nil }
      end

      context 'when user not found by email' do
        it 'return an error inside login_form' do
          expect(login_obj.login).to eq login_form
          expect(login_obj.login.errors.first).to_not be_nil
        end
      end

      context 'when user found' do
        before do
          allow(Db.user).to receive(:find_by_email){ user }
          allow(login_obj).to receive(:check_lock){ result }
        end

        it 'delegate to #check_lock' do
          expect(login_obj).to receive(:check_lock).with(user)
        end

        it 'returns #check_password result' do
          expect(login_obj.login).to eq result
        end
      end
    end

    describe '#check_lock' do
      let(:login_form){ double('login_form', errors: {}) }

      before do
        allow(login_obj).to receive(:login_form){ login_form }
        allow(user).to receive(:lock_code){ nil }
      end

      subject(:check_lock){ login_obj.send(:check_lock, user) }

      context 'when user lock' do
        before do
          allow(user).to receive(:lock_code){ 'unconfirm_email' }
        end

        it 'returns error' do
          expect(check_lock.errors.first.join).to include('lock', 'contact', 'support')
        end
      end

      context 'when user unlock' do
        before do
          allow(login_obj).to receive(:check_password){ result }
        end

        it 'delegate to #check_password' do
          expect(login_obj).to receive(:check_password).with(user)
          check_lock
        end

        it 'returns #check_password result' do
          expect(check_lock).to eq result
        end
      end
    end

    describe '#check_password' do
      let(:crypt){ double('crypt') }
      let(:password){ double('password') }
      let(:password_hash){ double('password_hash') }
      let(:login_form){ double('login_form', password: password, errors: {}) }

      before do
        allow(BCrypt::Password).to receive(:new).with(password_hash){ crypt }
        allow(crypt).to receive(:==).with(password){ false }
        allow(user).to receive(:password_hash){ password_hash }
        allow(login_obj).to receive(:login_form){ login_form }
      end

      subject(:check_password){ login_obj.send(:check_password, user) }

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
        it 'return an error inside login_form' do
          expect(check_password).to eq login_form
          expect(check_password.errors.first).to_not be_nil
        end
      end
    end

    describe '#authentify' do
      let(:remember_me){ double('remember_me') }
      let(:login_form){ double('login_form', remember_me: remember_me) }

      subject(:authentify){ login_obj.send(:authentify, user) }

      before do
        allow(login_obj).to receive(:login_form){ login_form }
        allow(app).to receive(:authentify_and_back)
      end        
      
      it 'authentify and redirect back' do
        expect(app).to receive(:authentify_and_back).with(user, remember_me)
        authentify
      end

      it 'returns login_form' do
        expect(authentify).to eq login_form
      end
    end
  end
end