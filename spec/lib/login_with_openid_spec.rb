require 'spec_helper'

module Vxod
  describe LoginWithOpenid do
    let(:rack_app_warp){ double('rack_app_warp') }
    let(:identity){ double('identity') }
    let(:user){ double('user') }
    let(:identity_class){ double('identity_class') }
    let(:provider){ rnd('provider') }
    let(:openid){ rnd('openid') }
    let(:auth_key){ rnd('auth_key') }
    let(:login_with_openid){ LoginWithOpenid.new(rack_app_warp) }

    before do
      allow(rack_app_warp).to receive(:omniauth_hash){{ uid: openid, provider: provider }}
      allow(rack_app_warp).to receive(:authentify)
      allow(rack_app_warp).to receive(:redirect_back)

      allow(Db).to receive(:identity){ identity_class }
      allow(identity_class).to receive(:find_by_openid).with(provider, openid){ identity }
      allow(identity).to receive(:user){ user }

      allow(user).to receive(:auth_key){ auth_key }
    end

    describe '#login' do
      context 'when identity exists and user has valid email' do
        before do
          allow(user).to receive(:email){ 'sergey@makridenkov.com' }
        end

        it 'authentify' do
          expect(rack_app_warp).to receive(:authentify).with(auth_key)
          login_with_openid.login
        end

        it 'redirect back' do
          expect(rack_app_warp).to receive(:redirect_back)
          login_with_openid.login
        end
      end
  
      context 'when identity not found' do
        it 'create identity'
        it 'create user'
        it 'redirect user back'
      end

      context 'when user have not valid email' do
        it 'authentify temporary'
        it 'redirect user to fill email page'
      end
    end
  end
end