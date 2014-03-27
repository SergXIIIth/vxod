require 'spec_helper'

describe 'Login with openid', :type => :feature, feature: true, js: true  do
  it 'allow access to secret page' do
    visit '/'
  end
end
