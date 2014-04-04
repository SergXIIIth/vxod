require 'mongoid'

module Vxod::Db
  module Mongoid
    class Openid
      include ::Mongoid::Document
      include ::Mongoid::Timestamps

      field :provider , type: String
      field :uid      , type: String
      field :raw      , type: Hash

      validates :provider, presence: true
      validates :uid, presence: true
      validates :uid, uniqueness: { scope: 'provider' }
      validates :raw, presence: true

      belongs_to :user

      index({ provider: 1, uid: 1 }, { unique: true })

      class << self
        def find_by_openid(provider, uid)
          Openid.where(provider: provider, uid: uid)[0]
        end
      end
    end

    class User
      include ::Mongoid::Document
      include ::Mongoid::Timestamps

      field :email        , type: String
      field :firstname    , type: String
      field :lastname     , type: String
      field :auth_key     , type: String
      field :password     , type: String
      field :lock_code    , type: String

      field :confirm_email_key  , type: String
      field :confirm_at         , type: DateTime

      validates :email, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/ }
      validates :email, presence: true
      validates :email, uniqueness: true
      validates :auth_key, presence: true
      validates :confirm_email_key, presence: true

      has_many :openids, dependent: :destroy

      index({ auth_key: 1 }, { unique: true })

      def name
        "#{firstname} #{lastname}"
      end

      class << self
        def find_by_auth_key(auth_key)
          User.where(auth_key: auth_key)[0]
        end

        def find_by_confirm_email_key(confirm_email_key)
          User.where(confirm_email_key: confirm_email_key)[0]
        end
      end
    end    
  end
end