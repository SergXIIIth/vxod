module Vxod
  class UserRepo
    class << self
      def create(params)
        build(params['firstname'], params['lastname'], params['email']).tap do |user|
          user.password = params['password']
          user.save
        end
      end

      def create_by_openid(openid, password)
        build_by_openid(openid).tap do |user|
          user.password = password
          user.save
        end
      end

      def create_by_clarify_openid(openid, params)
        create(params)
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