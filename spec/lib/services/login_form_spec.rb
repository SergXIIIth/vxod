require 'spec_helper'

module Vxod
  describe LoginForm do
    let(:login_form){ LoginForm.new }

    describe '#initialize' do
      it 'set #errors with hash' do
        expect(login_form.errors).to eq({})
      end

      it 'set remember_me to true' do
        expect(login_form.remember_me).to eq(true)
      end
    end

    describe '#init_by_params' do
      let(:email){ double('email') }
      let(:password){ double('password') }
      let(:remember_me){ double('remember_me') }

      subject(:init_by_params){ LoginForm.init_by_params({
        'email' => email,
        'password' => password,
        'remember_me' => remember_me,
      })}

      it 'set #email' do
        expect(init_by_params.email).to eq(email)
      end

      it 'set #password' do
        expect(init_by_params.password).to eq(password)
      end

      it 'set #remember_me' do
        expect(init_by_params.remember_me).to be_false
      end

      context 'when remember_me "on"' do
        let(:remember_me){ 'on' }
  
        it 'set #remember_me to true if ' do
          remember_me = 'on'
          expect(init_by_params.remember_me).to be_true
        end
      end

      it 'returns login_form' do
        expect(init_by_params).to be_a(LoginForm)
      end
    end
  end
end