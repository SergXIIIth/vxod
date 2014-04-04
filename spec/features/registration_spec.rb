require 'spec_helper'

describe 'Registration', :type => :feature, feature: true, js: true  do
  let(:email){ "sergey#{rnd}@makridenkov.com" }

  it 'shows errors when invalid data' do
    # Given I am on registration page
    # When I click on 'registration'
    # Then I should see an errors

    visit '/registration'
    click_on 'Register'

    expect(find('.alert-danger')).to have_content('Email is invalid')
  end

  it 'register an user when valid data' do
    # Given I am on registration page
    # Wnen I fill the form
    # And click on 'registration'
    # Then I should be on secret page
    # And I should get an email with password

    visit '/registration'
    fill_in('email', with: email)

    expect(Pony).to receive(:mail).with{|params| 
      expect(params[:to]).to eq email
    }

    click_on 'Register'

    click_on 'secret'
    expect(page).to have_content("I am secret page for #{email}")
  end
end
