require 'spec_helper'

describe Vxod::Instance do
  let(:rack_app){ double('rack_app') }
  let(:vxod){ Vxod::Instance.new(rack_app) }

  describe '#authorize' do
    context 'when not authorized' do
      it 'redirects to login path' do
        expect(rack_app).to receive(:redirect)
        vxod.authorize
      end

      it 'keeps back path'
    end
  end
end