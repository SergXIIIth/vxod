require 'mongoid'

module Vxod::Db::Mongoid
  module Openid
    def self.included(base)
      base.include(::Mongoid::Document)
      base.include(::Mongoid::Timestamps)

      base.field :provider , type: String
      base.field :uid      , type: String
      base.field :raw      , type: Hash

      base.validates :provider, presence: true
      base.validates :uid, presence: true
      base.validates :uid, uniqueness: { scope: 'provider' }
      base.validates :raw, presence: true

      base.belongs_to :user

      base.index({ provider: 1, uid: 1 }, { unique: true })

      base.extend(ClassMethods)
    end

    module ClassMethods
      def find_by_openid(provider, uid)
        where(provider: provider, uid: uid)[0]
      end
    end
  end
end