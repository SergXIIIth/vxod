require 'spec_helper'
require 'vxod/db/mongoid'

module Vxod
  describe Notify do
    let(:notify){ Notify.new }

    describe '#registration' do
      let(:host){ double('host') }
      let(:user){ double('user', email: double('email')) }
      let(:html){ double('html') }
      let(:auto_password){ double('auto_password') }

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
          expect(scope[:auto_password]).to eq auto_password
          expect(scope[:user]).to eq user
          expect(scope[:host]).to eq host
        }

        notify.registration(user, host, auto_password)
      end
    end
  end
end