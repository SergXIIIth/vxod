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
        if openid.user
          openid.user
        else
          data = OpenidRawParser.new(openid.raw)

          create_by_openid(openid, { 
            'firstname' => data.firstname,
            'lastname' => data.lastname,
            'email' => data.email,
          })
        end
      end

      def create_by_openid(openid, params)
        build(params['firstname'], params['lastname'], params['email']).tap do |user|
          saved = user.save
          
          if saved
            openid.user = user
            openid.save!
          end
        end
      end

      def build(firstname, lastname, email)
        Db.user.new.tap do |user|
          user.auth_key = SecureRandom.base64(64)
          user.confirm_email_key = SecureRandom.hex(20)
          user.firstname = firstname
          user.lastname = lastname
          user.email = email
        end
      end

      def build_by_openid(openid)
      end
    end
  end
end