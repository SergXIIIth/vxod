require 'spec_helper'

module Vxod
  describe Login do
    let(:app){ double('app') }
    let(:user){ double('user') }
    let(:login_obj){ Login.new(app) }

    before do
    end

    describe '#login' do
      let(:params){ double('params') }
      let(:email){ double('email') }
      let(:result){ double('result') }

      before do
        allow(app).to receive(:params){ params }
        allow(params).to receive(:[]).with('email'){ email }
        allow(Db.user).to receive(:find_by_email){ nil }
      end

      after { login_obj.login }

      it 'search user by email' do
        expect(Db.user).to receive(:find_by_email).with(email){ nil }
      end

      context 'when user not found by email' do
        it 'return an error' do
          expect(login_obj.login.success).to be_false
        end
      end

      context 'when user found' do
        before do
          allow(Db.user).to receive(:find_by_email){ user }
          allow(login_obj).to receive(:login_with_user){ result }
        end

        it 'delegate to #login_with_user' do
          expect(login_obj).to receive(:login_with_user).with(user)
        end

        it 'returns #login_with_user result' do
          expect(login_obj.login).to eq result
        end
      end
    end

    describe '#login_with_user' do
      context 'when password match' do
        it 'delegate to #authentify'
      end

      context 'when password do not match' do
        it 'return an error'
      end
    end

    describe '#authentify' do
      context 'when remember me' do
        it 'authentify and redirect back'
      end

      context 'when do not remember me' do
        it 'create session cookie'
        it 'authentify and redirect back'
      end
    end
  end
end