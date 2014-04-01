require 'spec_helper'
require 'vxod/db/mongoid'

module Vxod
  describe User do
    let(:user){ double('db_user') }

    before do
      allow(Db).to receive(:user){ db_user }
      allow(db_user).to receive(:new){ db_user }
    end

    describe '.register' do
      it 'set fields'
      it 'gerenate password when auto password'
      it 'generate auth_key'
      it 'save to db'
      it 'returns user'
    end

    # describe '.login_with_openid' do
    #   it 'create identity'
    #   it 'create user'
    # end
  end
end