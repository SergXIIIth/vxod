require 'spec_helper'
require 'vxod/db/mongoid'

module Vxod::Db::Mongoid
  describe User do
    let(:user_class) { Class.new { send(:include, Vxod::Db::Mongoid::User) } }
    let(:user){ user_class.new }

    describe '#password_valid?' do
      it 'require not empty password' do
        expect(user.password_valid?('')).to be_false
        expect(user.password_valid?(nil)).to be_false
        expect(user.errors[:password]).to_not be_nil
      end

      it 'checks min lenght' do
        expect(user.password_valid?('1234567')).to be_true
        expect(user.password_valid?('123456')).to be_false
        expect(user.errors[:password]).to_not be_nil
      end
    end
  end
end