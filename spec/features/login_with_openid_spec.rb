require 'spec_helper'

describe 'Login with openid', :feature  do
  let(:email){ "sergey#{rand(1000)}@makridenkov.com" }

  it 'allow access to secret page' do
    visit '/'
    click_on 'secret'
    find('.provider-vkontakte').click

    expect(find('.vxod-errors')).to have_content('Почта не может быть пустым')

    expect(Pony).to receive(:mail).with(hash_including(to: email))

    fill_in('email', with: email)
    find('.vxod-btn-primary').click

    expect(page).to have_content("I am secret page for #{email}")

    click_on('logout')

    expect(current_path).to eq '/'
  end
end
