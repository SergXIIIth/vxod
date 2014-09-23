require 'spec_helper'

describe 'Registration', :type => :feature, feature: true, js: true  do
  let(:email){ "sergey#{rand(1000)}@makridenkov.com" }

  it 'shows errors when invalid data' do
    visit '/registration'
    click_on 'Register'

    expect(find('.alert-danger')).to have_content('Email is invalid')
  end

  it 'register a user when valid data' do
    visit '/registration'
    fill_in('email', with: email)

    expect(Pony).to receive(:mail).with{|params|
      expect(params[:to]).to eq email
    }

    click_on 'Register'

    click_on 'secret'
    expect(page).to have_content("I am secret page for #{email}")
  end

  it 'register a user with invalid password' do
    visit '/registration'
    fill_in('email', with: email)
    uncheck('vxod-auto-password-swither')

    click_on 'Register'

    expect(find('.alert-danger')).to have_content('Password is required')
  end
end
