require 'spec_helper'

describe 'Login with openid', :type => :feature, feature: true, js: true  do
  let(:email){ "sergey#{rnd}@makridenkov.com" }

  it 'allow access to secret page' do
    # Given I am onhome page
    # When I click on secret page
    # And I click login with VK
    # Then I should see error about email on page
    # When I fill email and click continue
    # Then I should be on secret page
    # When I click on logout
    # Then I should be on home page

    visit '/'
    click_on 'secret'
    find('.fa-vk').click

    expect(find('.alert-danger')).to have_content("Email can't be blank")

    fill_in('email', with: email)
    find('.btn-primary').click

    expect(page).to have_content("I am secret page for #{email}")

    click_on('logout')

    expect(current_path).to eq '/'
  end
end
