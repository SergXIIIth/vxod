require 'spec_helper'
require 'vxod/db/mongoid'

module Vxod
  describe Notify do
    let(:host){ double('host') }
    let(:password){ double('password') }
    let(:notify){ Notify.new }
    let(:user){ double('user', email: double('email')) }

    describe '#registration' do
      let(:html){ double('html') }
      let(:send_password){ double('send_password') }

      before do
        allow(notify).to receive(:render){ html }
        allow(Pony).to receive(:mail)
      end

      after{ notify.registration(user, password, host, send_password) }

      it 'send email to user' do        
        expect(Pony).to receive(:mail).with{ |params|
          expect(params[:to]).to eq user.email 
          expect(params[:subject]).to_not be_nil 
          expect(params[:html_body]).to eq html 
        }
      end

      it 'render email templite' do
        expect(notify).to receive(:render).with { |templite, params|
          expect(templite).to include 'registration.slim'
          expect(params[:send_password]).to eq send_password
          expect(params[:password]).to eq password
          expect(params[:user]).to eq user
          expect(params[:host]).to eq host
        }
      end

      it 'default send_password is true' do
        expect(notify).to receive(:render).with { |templite, params|
          expect(params[:send_password]).to be_true
        }
        notify.registration(user, password, host)
      end
    end

    describe '#openid_registration' do
      let(:openid){ double('openid', user: user) }

      it 'invoike #registration' do
        expect(notify).to receive(:registration).with(user, password, host)
        notify.openid_registration(openid, password, host)
      end
    end
  end
end