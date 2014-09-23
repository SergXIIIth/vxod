require 'spec_helper'

describe 'Confirm email', :type => :feature, feature: true, js: true  do
  let(:email){ "sergey#{rand(1000)}@makridenkov.com" }
  let(:user) { Vxod::UserRepo.create('email' => email, 'password' => '1234567') }

  it 'show message when confirmed' do
    # Given I follow confirmation link
    # Then I should see message "Email confirmed"
    # And link to after login path
    visit "#{Vxod.config.confirm_email_path}?key=#{user.confirm_email_key}"

    expect(page).to have_content 'Confirm email success'
    expect(page).to have_content 'Continue'
  end

  it 'show error when confirmation invalid' do
    user.confirm_at = DateTime.now
    user.save!

    visit "#{Vxod.config.confirm_email_path}?key=#{user.confirm_email_key}"

    expect(page).to have_css '.alert-danger'
  end
end
