require 'spec_helper'

describe 'Reset password', :type => :feature, feature: true, js: true  do
  let(:email){ "sergey#{rnd}@makridenkov.com" }

  it 'copy email to reset password form' do
    visit '/login'
    fill_in('email', with: email)

    click_on 'Reset password'

    expect(current_path).to eq(Vxod.config.reset_password_path)
    expect(find('#email').value).to eq(email)
  end

  it 'send email with new password'
    # expect(Pony).to receive(:mail).with{|params| 
    #   expect(params[:to]).to eq email
    # }

  it 'show error when email invalid'
    #   expect(find('.alert-danger')).to have_content('Password is required')

end
