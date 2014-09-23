require 'spec_helper'

describe 'Login with password', :feature  do
  let(:email){ "sergey#{rand(1000)}@makridenkov.com" }
  let(:password){ "password#{rand}" }
  let(:user){ Vxod::UserRepo.create('email' => email, 'password' => password) }

  it 'allow access to secret page' do
    visit '/'

    click_on 'secret'

    fill_in('email', with: email)
    fill_in('password', with: password)

    find('[type="submit"]').click

    expect(page).to have_content("I am secret page for #{email}")
  end

  it 'show login error' do
    visit '/'

    click_on 'secret'

    fill_in('email', with: email)
    fill_in('password', with: 'wrong password')

    find('[type="submit"]').click

    expect(page).to have_css('.vxod-errors')
  end
end
