require 'spec_helper'

module Vxod
  describe App do
    describe '#after_login_path' do
      it 'take path from url param'
      it 'return default back path when no present in url'
    end

    describe '#authentify' do
      it 'set cookie with for whole domain with 10 years expires'
    end
  end
end