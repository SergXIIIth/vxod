module Vxod
  class Db
    class << self
      attr_accessor :identity, :user

      def identity_create(provider, openid, email, firstname, lastname)
        user = self.user.new
        user.auth_key = SecureRandom.base64(64)
        user.email = email
        user.firstname = firstname
        user.lastname = lastname
        user.save!

        identity = self.identity.new
        identity.provider = provider
        identity.openid = openid
        identity.user = user
        identity.save!

        identity
      end
    end
  end
end