require 'spec_helper'

module Vxod
  describe LoginForm do
    describe '#initialize' do
      it 'init #errors with hash' do
        expect(LoginForm.new.errors).to eq({})
      end
    end

    describe '#init_by_params' do
      let(:email){ double('email') }
      let(:password){ double('password') }
      let(:remember_me){ double('remember_me') }

      subject(:login_form){ LoginForm.init_by_params({
        'email' => email,
        'password' => password,
        'remember_me' => remember_me,
      })}

      it 'set #email' do
        expect(login_form.email).to eq(email)
      end

      it 'set #password' do
        expect(login_form.password).to eq(password)
      end

      it 'set #remember_me' do
        expect(login_form.remember_me).to eq(remember_me)
      end

      it 'returns login_form' do
        expect(login_form).to be_a(LoginForm)
      end
    end
  end
end