require 'spec_helper'
require 'vxod/db/mongoid'

module Vxod
  describe Registrator do
    let(:app){ double('app') }
    let(:registrator){ Registrator.new(app) }

    describe 'register' do
      let(:params){ {} }
      let(:user){ double('valid?' => false) }
      let(:notify){ double('notify', registration: 1) }
      let(:host){ double('host') }


      before do
        allow(app).to receive(:params){ params }
        allow(app).to receive(:request_host){ host }
        allow(UserRepo).to receive(:register){ user }
        allow(Notify).to receive(:new){ notify }
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
  end
end