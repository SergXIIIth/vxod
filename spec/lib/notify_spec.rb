require 'spec_helper'
require 'vxod/db/mongoid'

module Vxod
  describe Notify do
    let(:host){ double('host') }
    let(:notify){ Notify.new }
    let(:user){ double('user', email: double('email')) }

    describe '#registration' do
      let(:html){ double('html') }
      let(:send_password){ double('send_password') }

      before do
        allow(notify).to receive(:render){ html }
        allow(Pony).to receive(:mail)
      end

      it 'send email to user' do        
        expect(Pony).to receive(:mail).with{ |params|
          expect(params[:to]).to eq user.email 
          expect(params[:subject]).to_not be_nil 
          expect(params[:html_body]).to eq html 
        }

        notify.registration(user, host)
      end

      it 'render email templite' do
        expect(notify).to receive(:render).with { |templite, scope|
          expect(templite).to include 'registration.slim'
          expect(scope[:send_password]).to eq send_password
          expect(scope[:user]).to eq user
          expect(scope[:host]).to eq host
        }

        notify.registration(user, host, send_password)
      end
    end

    describe '#openid_registration' do
      let(:openid){ double('openid', user: user) }

      it 'invoike #registration' do
        expect(notify).to receive(:registration).with(user, host)
        notify.openid_registration(openid, host)
      end
    end
  end
end