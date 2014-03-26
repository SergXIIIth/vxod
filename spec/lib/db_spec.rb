require 'spec_helper'

module Vxod
  describe Db do
    let(:identity){ double('identity') }
    let(:user){ double('user') }

    # describe '.identity_create' do
    #   it 'create identity'
    #   it 'create user'
    # end

    describe '.identity' do
      it 'accessable' do
        Db.identity = identity
        expect(Db.identity).to eq identity
      end
    end

    describe '.user' do
      it 'accessable' do
        Db.user = user
        expect(Db.user).to eq user
      end
    end
  end
end