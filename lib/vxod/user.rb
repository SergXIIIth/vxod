module Vxod
  class User
    class << self
      def register(params)
        user = Db.user.new
        
        user.firstname = params['firstname']
        user.lastname = params['lastname']
        user.email = params['email']
        user.password = params['auto_password'] ? SecureRandom.hex(4) : params['password']
        user.auth_key = SecureRandom.base64(64)

        user.save

        user
      end

      def create_openid(provider, openid, email, firstname, lastname)
        user = Db.user.new
        user.auth_key = SecureRandom.base64(64)
        user.email = email
        user.firstname = firstname
        user.lastname = lastname
        user.save!

        openid = Db.openid.new
        openid.provider = provider
        openid.openid = openid
        openid.user = user
        openid.save!

        user
      end
    end
  end
end