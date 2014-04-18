require 'spec_helper'

describe 'Login with password', :type => :feature, feature: true, js: true  do
  let(:email){ "sergey#{rnd}@makridenkov.com" }
  let(:password){ rnd('password') }
  let(:user){ Vxod::UserRepo.create(
    'email' => email, 
    'password' => password
  )}

  it 'allow access to secret page' do
    # Given I am on home page
    # And I have an account registerd
    # When I click on secret page
    # And fill in email, password
    # And submit login form
    # Then I should be on secret page

    # Given I am on home page
    visit '/'

    # And I have an account registerd
    expect(user.valid?).to be_true

    # When I click on secret page
    click_on 'secret'

    # And fill in email, password
    fill_in('email', with: email)
    fill_in('password', with: password)

    # And submit login form
    find('.btn-primary').click

    # Then I should be on secret page
    expect(page).to have_content("I am secret page for #{email}")
  end

  it 'show login error'
end
