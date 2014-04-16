require 'spec_helper'
require 'vxod/db/mongoid'

module Vxod
  describe Registrator do
    let(:app){ double('app') }
    let(:registrator){ Registrator.new(app) }
    let(:user){ double('valid?' => false) }
    let(:notify){ double('notify', registration: 1) }
    let(:host){ double('host') }

    before do
      allow(app).to receive(:request_host){ host }
      allow(Notify).to receive(:new){ notify }
    end

    describe '#register' do
      let(:params){ {} }

      before do
        allow(app).to receive(:params){ params }
        allow(UserRepo).to receive(:register){ user }
      end

      it 'register user' do
        expect(UserRepo).to receive(:register){ user }
        registrator.register
      end

      it 'convert params["auto_password"] = nil to false' do
        expect(UserRepo).to receive(:register).with{ |params|
          expect(params['auto_password']).to eq false
        }

        registrator.register
      end

      it 'generate password if params["password"] missing'

      it 'convert params["auto_password"] = "on" to true' do
        params['auto_password'] = 'on'

        expect(UserRepo).to receive(:register).with{ |params|
          expect(params['auto_password']).to eq true
        }

        registrator.register
      end

      context 'when user data is valid' do
        before do
          allow(user).to receive(:valid?){ true }
          allow(app).to receive(:authentify_and_back)
          allow(Notify).to receive(:registration)
        end

        it 'authentify user and redirect back' do
          expect(app).to receive(:authentify_and_back).with(user)
          registrator.register
        end

        it 'notify user about new registration' do
          params['auto_password'] = 'on'

          expect(notify).to receive(:registration).with(user, host, true)

          registrator.register
        end
      end
    end

    describe '#register_by_openid' do
      let(:openid){ double('openid') }

      before do
        allow(app).to receive(:redirect_to_fill_openid).with(openid)
        allow(UserRepo).to receive(:create_by_openid){ user }
      end
      
      after{ registrator.register_by_openid(openid) }

      it 'create user' do
        expect(UserRepo).to receive(:create_by_openid).with(openid){ user }
      end

      context 'when user unvalid' do
        it 'redirect to fill openid page when user invalid' do
          expect(app).to receive(:redirect_to_fill_openid).with(openid)
        end
      end

      context 'when user valid' do
        before do
          allow(user).to receive('valid?'){ true }
          allow(notify).to receive(:openid_registration).with(openid, host)
          allow(app).to receive(:authentify_and_back).with(user)
        end

        it 'notify user about openid registration' do
          expect(notify).to receive(:openid_registration).with(openid, host)
        end

        it 'authentify and redirect back' do
          expect(app).to receive(:authentify_and_back).with(user)
        end
      end
    end

    describe '#register_by_clarify_openid' do
      it 'create user with auto password'
      it 'return user'

      context 'when registration success' do
        it 'notify user about openid registration'
        it 'authentify and redirect back'
      end
    end
  end
end