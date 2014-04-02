require 'spec_helper'

module Vxod
  describe OpenidLogin do
    let(:app){ double('app') }
    let(:user){ double('user') }
    let(:openid){ double('openid') }
    let(:openid_login){ OpenidLogin.new(app) }

    before do
      allow(app).to receive(:authentify_and_back)
    end

    describe 'update_openid_data' do
      let(:params){ double('params') }

      before do
        allow(app).to receive(:params){ params }
        allow(app).to receive(:current_openid){ openid }
        allow(UserRepo).to receive(:create_by_openid){ user }
        allow(user).to receive('valid?'){ false }
      end 

      it 'try create user by openid' do
        expect(app).to receive(:params){ params }
        expect(app).to receive(:current_openid){ openid }
        expect(UserRepo).to receive(:create_by_openid).with(openid, params)

        openid_login.update_openid_data
      end

      it 'authentify and redirect back when user valid' do
        allow(user).to receive('valid?'){ true }
        expect(app).to receive(:authentify_and_back).with(user)
        openid_login.update_openid_data
      end

      it 'return user' do
        expect(openid_login.update_openid_data).to eq user
      end
    end

    describe 'show_openid_data' do
      before do
        allow(app).to receive(:current_openid){ openid }
        allow(UserRepo).to receive(:find_or_create_by_openid){ user }
        allow(user).to receive('valid?'){ false }
      end 

      it 'try create user from app.current_openid' do
        expect(app).to receive(:current_openid){ openid }
        expect(UserRepo).to receive(:find_or_create_by_openid).with(openid)

        openid_login.show_openid_data
      end

      it 'authentify and redirect back when user valid' do
        allow(user).to receive('valid?'){ true }
        expect(app).to receive(:authentify_and_back).with(user)
        openid_login.show_openid_data
      end

      it 'return user' do
        expect(openid_login.show_openid_data).to eq user
      end
    end

    describe '#login' do
      let(:openid){ double('openid') }
      let(:omniauth_hash){ double('omniauth_hash') }
  
      before do
        allow(app).to receive(:omniauth_hash){ omniauth_hash }
        allow(OpenidRepo).to receive(:find_or_create){ openid }
        allow(UserRepo).to receive(:find_or_create_by_openid){ user }
        allow(user).to receive('valid?'){ true }
      end

      it 'find or create openid' do
        expect(OpenidRepo).to receive(:find_or_create).with(omniauth_hash)
        openid_login.login
      end

      it 'find or create user by openid' do
        expect(UserRepo).to receive(:find_or_create_by_openid).with(openid)
        openid_login.login
      end

      it 'authentify and redirect back when user valid' do
        expect(app).to receive(:authentify_and_back).with(user)
        openid_login.login
      end 

      it 'redirect to fill openid page when user invalid' do
        allow(user).to receive('valid?'){ false }
        expect(app).to receive(:redirect_to_fill_openid).with(openid)
        openid_login.login
      end
    end
  end
end