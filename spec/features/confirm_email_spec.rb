require 'spec_helper'

describe 'Confirm email', :type => :feature, feature: true, js: true  do
  let(:email){ "sergey#{rnd}@makridenkov.com" }

  it 'show message when confirmed' do
    # Given I follow confirmation link
    # Then I should see message "Email confirmed"
    # And link to after login path
    user = Vxod::UserRepo.register('email' => email)

    visit "#{Vxod.config.confirm_email_path}?key=#{user.confirm_email_key}"

    expect(page).to have_content 'Email confirmed'
    expect(page).to have_content 'Continue'
  end

  it 'show error when confirmation invalid' do
    visit "#{Vxod.config.confirm_email_path}?key=1234"

    expect(page).to have_css '.alert-danger'
  end
end
