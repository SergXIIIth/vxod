module Vxod
  module Db
    class << self
      attr_accessor :openid, :user

      def identity_create(provider, openid, email, firstname, lastname)
        user = self.user.new
        user.auth_key = SecureRandom.base64(64)
        user.email = email
        user.firstname = firstname
        user.lastname = lastname
        user.save!

        openid = self.openid.new
        openid.provider = provider
        openid.openid = openid
        openid.user = user
        openid.save!

        openid
      end
    end
  end
end