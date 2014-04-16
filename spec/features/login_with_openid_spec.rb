require 'spec_helper'

describe 'Login with openid', :type => :feature, feature: true, js: true  do
  let(:email){ "sergey#{rnd}@makridenkov.com" }

  it 'allow access to secret page' do
    # Given I am on home page
    # When I click on secret page
    # And I click login with VK
    # Then I should see error about email on page
    # When I fill email and click continue
    # Then I should be on secret page
    # And I should receive email with email/password
    # When I click on logout
    # Then I should be on home page

    # Given I am on home page
    visit '/'
    # When I click on secret page
    click_on 'secret'
    # And I click login with VK
    find('.fa-vk').click

    # Then I should see error about email on page
    expect(find('.alert-danger')).to have_content('Email is invalid')

    # And I should receive email with email/password
    expect(Pony).to receive(:mail).with{|params| 
      expect(params[:to]).to eq email
    }

    # When I fill email and click continue
    fill_in('email', with: email)
    find('.btn-primary').click

    # Then I should be on secret page
    expect(page).to have_content("I am secret page for #{email}")

    # When I click on logout
    click_on('logout')

    # Then I should be on home page
    expect(current_path).to eq '/'
  end
end
