require 'spec_helper'
require 'vxod/db/mongoid'

module Vxod
  describe Registrator do
    let(:app){ double('app') }
    let(:registrator){ Registrator.new(app) }

    describe 'register' do
      let(:params){ {} }
      let(:user){ double('valid?' => false) }

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
        end

        it 'authentify user and redirect back' do
          expect(app).to receive(:authentify_and_back).with(user)
          registrator.register
        end

        it 'notify user about new registration'
      end
    end
  end
end