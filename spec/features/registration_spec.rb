require 'spec_helper'

describe 'Registration', :feature  do
  let(:email){ "sergey#{rand(1000)}@makridenkov.com" }

  it 'shows errors when invalid data' do
    visit '/registration'
    find('[type="submit"]').click

    expect(find('.vxod-errors')).to have_content('Почта не может быть пустым')
  end

  it 'register a user when valid data' do
    visit '/registration'
    fill_in('email', with: email)

    expect(Pony).to receive(:mail).with(hash_including(to: email))

    find('[type="submit"]').click

    click_on 'secret'
    expect(page).to have_content("I am secret page for #{email}")
  end

  it 'register a user with invalid password', :js do
    visit '/registration'
    fill_in('email', with: email)
    uncheck('vxod-auto-password-swither')

    find('[type="submit"]').click

    expect(find('.vxod-errors')).to have_content('Пароль не может быть пустым')
  end
end
