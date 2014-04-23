require 'spec_helper'

module Vxod
  describe OpenidLogin do
    let(:app){ double('app') }
    let(:user){ double('user') }
    let(:openid){ double('openid') }
    let(:openid_login){ OpenidLogin.new(app) }
    let(:notify){ double('notify') }
    let(:host){ double('host') }
    let(:registrator){ double('registrator') }

    before do
      allow(app).to receive(:request_host){ host }
      allow(Notify).to receive(:new){ notify }
      allow(Registrator).to receive(:new){ registrator }
      allow(user).to receive('valid?'){ false }
    end

    describe '#login' do
      let(:openid){ double('openid') }
      let(:omniauth_hash){ double('omniauth_hash') }

      before do
        allow(app).to receive(:omniauth_hash){ omniauth_hash }
        allow(app).to receive(:authentify_and_back)
        allow(OpenidRepo).to receive(:find_or_create){ openid }
        allow(openid).to receive(:user){ user }
      end

      after { openid_login.login }

      it 'find or create openid' do
        expect(OpenidRepo).to receive(:find_or_create).with(omniauth_hash)
      end

      context 'when user exist' do
        context 'when lock' do
          it 'returns LoginForm with errors'
        end

        context 'when unlock' do
          it 'returns LoginForm'

          it 'authentify and redirect back' do
            expect(app).to receive(:authentify_and_back).with(user)
          end
        end
      end

      context 'when user not exist' do
        before do
          allow(openid).to receive(:user){ nil }
        end

        it 'returns LoginForm'
        
        it 'register user by openid' do
          expect(registrator).to receive(:register_by_openid).with(openid)
        end
      end
    end

    describe '#update_openid_data' do
      before do
        allow(app).to receive(:current_openid){ openid }
        allow(registrator).to receive(:register_by_clarify_openid){ user }
      end

      after{ openid_login.update_openid_data }

      it 'register user' do
        expect(registrator).to receive(:register_by_clarify_openid).with(openid)
      end
      
      it 'return user' do
        expect(openid_login.update_openid_data).to eq user
      end
    end

    describe '#show_openid_data' do
      before do
        allow(app).to receive(:current_openid){ openid }
        allow(openid).to receive(:user){ user }
      end

      after { openid_login.show_openid_data }

      it 'find user by app#current_openid' do
        expect(app).to receive(:current_openid){ openid }
      end

      it 'fill up user#errors' do
        expect(user).to receive('valid?')
      end

      it 'return user' do
        expect(openid_login.show_openid_data).to eq user
      end

      context 'when user not exist' do
        before do
          allow(openid).to receive(:user){ nil }
        end

        it 'build user by openid' do
          expect(UserRepo).to receive(:build_by_openid).with(openid){ user }
        end
      end
    end
  end
end