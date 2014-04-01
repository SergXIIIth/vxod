require 'spec_helper'
require 'vxod/db/mongoid'

module Vxod
  describe Registrator do
    let(:app){ double('app') }
    let(:registrator){ Registrator.new(app) }

    describe 'register' do
      let(:params){ double('params') }

      before do
        allow(app).to receive(:params){ params }
      end

      it 'register user' do
        expect(User).to receive(:register).with{ params }
        registrator.register
      end

      it 'notify user about new registration when user#valid?'
    end
  end
end