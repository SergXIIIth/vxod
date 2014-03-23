require 'spec_helper'

describe Vxod::Config do
  let(:config){ Vxod::Config.new }

  describe '#login_path' do
    it 'has default value' do
      expect(config.login_path).to eq 'login'
    end
  end
end