require 'spec_helper'

describe 'Login with openid', :type => :feature, feature: true, js: true  do
  let(:email){ "sergey#{rnd}@makridenkov.com" }

  it 'allow access to secret page' do
    # visit home page
    # click secret page
    # click login with VK
    # fill email and click continue
    # I should be on secret page
    # I click on logout
    # I should be on ?home page?

    visit '/'
    click_on 'secret'
    find('.fa-vk').click
    fill_in('email', with: email)
    find('.btn-primary').click

    expect(page).to have_content("I am secret page for #{email}")

    fail('Finish test')
  end
end
