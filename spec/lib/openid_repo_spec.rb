require 'spec_helper'
require 'vxod/db/mongoid'

module Vxod
  describe OpenidRepo do
    let(:provider){ double('provider') }
    let(:uid){ double('uid') }
    let(:omniauth_hash){ { uid: uid, provider: provider } }
    let(:openid){ double('openid') }

    before do
      allow(Db).to receive(:openid){ openid }
      allow(Db.openid).to receive(:find_by_openid)
    end

    describe '#find_or_create' do
      it 'returns openid when found by provider,uid' do
        expect(Db.openid).to receive(:find_by_openid).with(provider, uid){ openid }
        res = OpenidRepo.find_or_create(omniauth_hash)
        expect(res).to eq(openid)
      end

      it 'create openid when not found' do
        expect(OpenidRepo).to receive(:create).with(omniauth_hash)
        OpenidRepo.find_or_create(omniauth_hash)
      end
    end

    describe '#create' do
      let(:openid){ double('provider=' => 1, 'uid=' => 1, 'raw=' => 1, 'save!' => 1, ) }

      before do
        allow(Db.openid).to receive(:new){ openid }
      end

      it 'set provider' do
        expect(openid).to receive('provider=').with(provider)
        OpenidRepo.create(omniauth_hash)
      end

      it 'set uid' do
        expect(openid).to receive('uid=').with(uid)
        OpenidRepo.create(omniauth_hash)
      end
      
      it 'set raw' do
        expect(openid).to receive('raw=').with(omniauth_hash)
        OpenidRepo.create(omniauth_hash)
      end

      it 'save to db' do
        expect(openid).to receive('save!')
        OpenidRepo.create(omniauth_hash)
      end

      it 'returns openid' do
        expect(OpenidRepo.create(omniauth_hash)).to eq(openid)
      end
    end
  end
end