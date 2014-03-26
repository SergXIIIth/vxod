require 'mongoid'

module Vxod::Db
  module Mongoid
    class Identity
      include ::Mongoid::Document
      include ::Mongoid::Timestamps

      field :provider , type: String
      field :openid   , type: String

      belongs_to :user

      index({ provider: 1, social_id: 1 }, { unique: true })

      class << self
        def find_by_openid(provider, openid)
          Identity.where(provider: provider, openid: openid)[0]
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
      
      has_many :identities

      def name
        "#{firstname} #{lastname}"
      end
    end    
  end
end