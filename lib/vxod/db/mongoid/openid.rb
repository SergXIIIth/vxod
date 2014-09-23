require 'mongoid'

module Vxod::Db::Mongoid
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
        where(provider: provider, uid: uid)[0]
      end
    end
  end
end
