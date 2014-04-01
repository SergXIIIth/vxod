require 'spec_helper'

module Vxod
  describe Db do
    let(:openid){ double('openid') }
    let(:user){ double('user') }

    describe '.openid' do
      it 'accessable' do
        Db.openid = openid
        expect(Db.openid).to eq openid
      end
    end

    describe '.user' do
      it 'accessable' do
        allow(Db).to receive(:user){ user }
        expect(Db.user).to eq user
      end
    end
  end
end