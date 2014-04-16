module Vxod
  class UserRepo
    class << self
      def register(params)
        build(params['firstname'], params['lastname'], params['email']).tap do |user|
          user.password = params['auto_password'] ? generate_password : params['password']
          user.save
        end
      end

      def create_by_openid(openid)
        build_by_openid(openid).tap do |user|
          user.password = generate_password
          user.save
        end
      end

      def create_by_clarify_openid(openid, params)
        build(params['firstname'], params['lastname'], params['email']).tap do |user|
          user.password = generate_password
          user.save
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
        data = OpenidRawParser.new(openid.raw)
        build(data.firstname, data.lastname, data.email)
      end

      def generate_password
        SecureRandom.hex(4)
      end
    end
  end
end