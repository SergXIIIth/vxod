require 'spec_helper'
require 'vxod/db/mongoid'

module Vxod::Db::Mongoid
  describe User do
    describe '#password_valid?' do
      it 'requred'
      it 'min lenght'
      it 'put errors in #errors'
      it 'true when valid'
      it 'false when invalid'
    end
  end
end