require 'spec_helper'

describe 'Login with openid', :type => :feature, feature: true, js: true  do
  let(:email){ "sergey#{rand(1000)}@makridenkov.com" }

  it 'allow access to secret page' do
    visit '/'
    click_on 'secret'
    find('.fa-vk').click

    expect(find('.alert-danger')).to have_content('Email is invalid')

    expect(Pony).to receive(:mail).with{|params|
      expect(params[:to]).to eq email
    }

    fill_in('email', with: email)
    find('.btn-primary').click

    expect(page).to have_content("I am secret page for #{email}")

    click_on('logout')

    expect(current_path).to eq '/'
  end
end
