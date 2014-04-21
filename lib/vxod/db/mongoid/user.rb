require 'mongoid'

module Vxod::Db::Mongoid
  module User
    def password_valid?(password_uncrypt)
      errors.add(password: 'is required') if password_uncrypt.blank?
    end

    def self.included(base)
      base.include ::Mongoid::Document
      base.include ::Mongoid::Timestamps

      base.field :email        , type: String
      base.field :firstname    , type: String
      base.field :lastname     , type: String
      base.field :auth_key     , type: String
      base.field :password_hash, type: String
      # 'unconfirm_email' when user click in email in 'I did not require registration'
      base.field :lock_code    , type: String 

      base.field :confirm_email_key  , type: String
      base.field :confirm_at         , type: DateTime

      base.validates :email, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/ }
      base.validates :email, presence: true
      base.validates :email, uniqueness: true
      base.validates :password_hash, presence: true
      base.validates :auth_key, presence: true
      base.validates :confirm_email_key, presence: true

      base.has_many :openids, dependent: :destroy

      base.index({ auth_key: 1 }, { unique: true })
      base.index({ email: 1 }, { unique: true })
      base.index({ confirm_email_key: 1 }, { unique: true })

      base.extend(ClassMethods)
    end

    module ClassMethods
      def find_by_auth_key(auth_key)
        where(auth_key: auth_key)[0]
      end

      def find_by_email(email)
        where(email: email)[0]
      end

      def find_by_confirm_email_key(confirm_email_key)
        where(confirm_email_key: confirm_email_key)[0]
      end
    end
  end   
end