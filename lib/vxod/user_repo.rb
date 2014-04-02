module Vxod
  class UserRepo
    class << self
      def register(params)
        build(params['firstname'], params['lastname'], params['email']).tap do |user|
          user.password = params['auto_password'] ? SecureRandom.hex(4) : params['password']
          user.save
        end
      end

      def find_or_create_by_openid(openid)
        data = OpenidRawParser.new(openid.raw)
        
        if openid.user
          openid.user
        else
          build(data.firstname, data.lastname, data.email).tap do |user|
            user.save
          end
        end
      end

      def create_by_openid(openid, params)
      end

      def build(firstname, lastname, email)
        Db.user.new.tap do |user|
          user.auth_key = SecureRandom.base64(64)
          user.firstname = firstname
          user.lastname = lastname
          user.email = email
        end
      end
    end
  end
end