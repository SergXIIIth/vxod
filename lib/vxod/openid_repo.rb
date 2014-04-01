module Vxod
  class OpenidRepo
    class << self
      def find_or_create(omniauth_hash)
        data = OpenidRawParser.new(omniauth_hash)

        openid = Db.openid.find_by_openid(data.provider, data.uid)

        openid ||= create(data.provider, data.uid, omniauth_hash)

        openid
      end

      def create(omniauth_hash)
        data = OpenidRawParser.new(omniauth_hash)

        openid = Db.openid.new
        openid.provider = data.provider
        openid.uid = data.uid
        openid.raw = omniauth_hash

        openid.save!

        openid
      end

    end
  end
end