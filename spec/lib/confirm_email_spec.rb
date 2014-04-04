require 'spec_helper'
require 'vxod/db/mongoid'

module Vxod
  describe ConfirmEmail do
    let(:app){ double('app') }
    let(:user){ double('user') }
    let(:key){ double('key') }
    let(:confirm_email){ ConfirmEmail.new(app) }
    let(:params){{ 'key' => key }}

    before do
      allow(app).to receive(:params){ params }
      allow(user).to receive(:confirm_at){ nil }
      allow(Db.user).to receive(:find_by_confirm_email_key){ user }
    end

    describe '#confirm' do
      context 'when user not found by key' do
        it 'raise fail - confirmation link without key app.requst_path' do
          allow(app).to receive(:request_path)
          allow(Db.user).to receive(:find_by_confirm_email_key){ nil }
          expect{ confirm_email.confirm }.to raise_error
        end
      end

      context 'when user#confirm_at already set' do
        it 'return { success: false, error: [ "Email already confirmed" ]}' do
          allow(user).to receive(:confirm_at){ double('confirm_at') }
          expect(confirm_email.confirm).to eq({ success: false, error: [ "Email already confirmed" ] })
        end
      end
      
      context 'when lock = 1' do
        it 'set User#lock_code to unconfirm_email'
        it 'save a user'
        it 'return { success: false, error: [ "Thanks, we break registration. If any questions please conntact support" ]}'
      end

      context 'when key valid, no confirm_at, no lock' do
        before do
          allow(user).to receive(:confirm_at=)
          allow(user).to receive(:save!)
        end

        after{ confirm_email.confirm }

        it 'seacrh user by key' do
          expect(Db.user).to receive(:find_by_confirm_email_key).with(key)
        end

        it 'set user.confirm_at to now' do
          now = double('now')
          allow(DateTime).to receive(:now){ now }

          expect(user).to receive(:confirm_at=).with(now)
        end

        it 'save a user' do
          expect(user).to receive(:save!)
        end

        it 'return { success: true }' do
          expect(confirm_email.confirm).to eq({ success: true })
        end
      end
    end
  end
end