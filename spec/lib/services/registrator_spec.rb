require 'spec_helper'
require 'vxod/db/mongoid'

module Vxod
  describe Registrator do
    let(:app){ double('app') }
    let(:params){ {} }
    let(:registrator){ Registrator.new(app) }
    let(:user){ double(errors: {test: 1} ) }
    let(:notify){ double('notify', registration: 1) }
    let(:host){ double('host') }
    let(:openid){ double('openid') }
    let(:password){ double('password') }

    before do
      allow(app).to receive(:request_host){ host }
      allow(Notify).to receive(:new){ notify }
    end

    describe '#params' do
      before do
        allow(app).to receive(:params){ params }
        allow(registrator).to receive(:password){ password }
      end

      subject('call_params'){ registrator.send(:params) }

      it 'prevent app.params from changes' do
        expect(params).to receive(:clone){ params }
        call_params
      end

      it 'add password to app params' do
        expect(call_params['password']).to eq password
      end
    end

    describe '#password' do
      before do
        allow(app).to receive(:params){ params }
      end

      subject('call_password'){ registrator.send(:password) }

      context 'when auto password' do
        before do
          params['auto_password'] = 'on'
        end

        it 'generate password' do
          expect(SecureRandom).to receive(:hex).with(4){ password }
          expect(call_password).to eq password
        end
      end

      context 'when not auto password' do
        before do
          params['password'] = password
        end

        it 'returns password from request' do
          expect(call_password).to eq password
        end
      end
    end

    describe '#register' do
      before do
        allow(UserRepo).to receive(:create){ user }
        allow(registrator).to receive(:params){ params }
      end

      after{ registrator.register }

      it 'create user in DB' do
        expect(UserRepo).to receive(:create).with(params)
      end

      context 'when user data is valid' do
        before do
          allow(user).to receive(:errors){ {} }
          allow(app).to receive(:authentify_and_back)
          allow(Notify).to receive(:registration)
          allow(registrator).to receive(:password){ password }
        end

        it 'authentify user and redirect back' do
          expect(app).to receive(:authentify_and_back).with(user)
        end

        it 'notify user about new registration' do
          expect(notify).to receive(:registration).with(user, password, host)
        end
      end
    end

    describe '#register_by_openid' do
      before do
        allow(app).to receive(:redirect_to_fill_openid).with(openid)
        allow(UserRepo).to receive(:create_by_openid){ user }
        allow(registrator).to receive(:generate_password){ password }
      end
      
      after{ registrator.register_by_openid(openid) }

      it 'create user with auto password' do
        expect(UserRepo).to receive(:create_by_openid).with(openid, password){ user }
      end

      context 'when user unvalid' do
        it 'redirect to fill openid page when user invalid' do
          expect(app).to receive(:redirect_to_fill_openid).with(openid)
        end
      end

      context 'when user unvalid' do
        before do
          allow(user).to receive(:errors){ {} }
        end

        it 'invoke openid_registered' do
          expect(registrator).to receive(:openid_registered).with(openid, user)
        end
      end
    end

    describe '#register_by_clarify_openid' do
      before do
        allow(UserRepo).to receive(:create_by_clarify_openid).with(openid, params){ user }
        allow(registrator).to receive(:openid_registered).with(openid, user)
        allow(registrator).to receive(:params){ params }
      end

      after{ registrator.register_by_clarify_openid(openid) }

      it 'create user with auto password' do
        expect(registrator).to receive(:generate_password){ password }

        expect(UserRepo).to receive(:create_by_clarify_openid).with{|openid, params|
          expect(params['password']).to eq password
        }{ user }
      end

      it 'invoke openid_registered' do
        expect(registrator).to receive(:openid_registered).with(openid, user)
      end
    end

    describe '#openid_registered' do
      subject('openid_registered'){ registrator.send(:openid_registered, openid, user) }

      after{ openid_registered }

      it 'returns user' do
        expect(openid_registered).to eq user
      end

      context 'when user valid' do
        before do
          allow(user).to receive(:errors){ {} }
          allow(openid).to receive('user=').with(user)
          allow(openid).to receive('save!')
          allow(notify).to receive(:openid_registration)
          allow(app).to receive(:authentify_and_back)
          allow(registrator).to receive(:password){ password }
        end

        it 'link user with openid' do
          expect(openid).to receive('user=').with(user)
          expect(openid).to receive('save!')
        end

        it 'notify user about openid registration' do
          expect(notify).to receive(:openid_registration).with(openid, password, host)
        end

        it 'authentify and redirect back' do
          expect(app).to receive(:authentify_and_back).with(user)
        end
      end
    end
  end
end