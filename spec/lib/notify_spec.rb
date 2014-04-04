require 'spec_helper'
require 'vxod/db/mongoid'

module Vxod
  describe Notify do
    describe '.registration' do
      let(:user){ double('user', email: double('email')) }
      let(:html){ double('html') }
      let(:auto_password){ double('auto_password') }

      before do
        allow(Notify).to receive(:render){ html }
        allow(Pony).to receive(:mail)
      end

      it 'send email to user' do        
        expect(Pony).to receive(:mail).with{ |params|
          expect(params[:to]).to eq user.email 
          expect(params[:subject]).to_not be_nil 
          expect(params[:html_body]).to eq html 
        }

        Notify.registration(user)
      end

      it 'render email templite' do
        expect(Notify).to receive(:render).with { |templite, user, scope|
          expect(templite).to include 'registration.slim'
          expect(user).to eq user
          expect(scope[:auto_password]).to eq auto_password
        }

        Notify.registration(user, auto_password)
      end
    end
  end
end