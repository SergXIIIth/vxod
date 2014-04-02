require 'spec_helper'

describe 'Registration', :type => :feature, feature: true, js: true  do
  let(:email){ "sergey#{rnd}@makridenkov.com" }

  context 'when invalid data' do
    it 'shows errors' do
      # Given I am on registration page
      # When I click on 'registration'
      # Then I should see an errors

      # visit '/registration'
      # click_on 'Register'

      # expect(page).to have_content('Email is required')
    end
  end

  context 'when valid data' do
    it 'register an user'
      # Given I am on registration page
      # Wnen I fill the form
      # And click on 'registration'
      # Then I should be on login page
      # And see message prease check email for password
      # And I should get an Email
  end
end
