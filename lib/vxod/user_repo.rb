module Vxod
  class UserRepo
    class << self
      def create(params)
        user = build(params['firstname'], params['lastname'], params['email'])
        create_with_password(user, params['password'])
      end

      def create_by_openid(openid, password)
        user = build_by_openid(openid)
        create_with_password(user, password)
      end

      def create_by_clarify_openid(openid, params)
        create(params)
      end

      def build_by_openid(openid)
        data = OpenidRawParser.new(openid.raw)
        build(data.firstname, data.lastname, data.email)
      end

private

      def build(firstname, lastname, email)
        user = Db.user.new

        user.auth_key = SecureRandom.base64(64)
        user.confirm_email_key = SecureRandom.hex(20)

        user.firstname = firstname
        user.lastname = lastname
        user.email = email

        user
      end

      def create_with_password(user, password)
        if user.password_valid?(password)
          user.password_hash = BCrypt::Password.create(password)
          user.save
        end

        user
      end

      def generate_password
        SecureRandom.hex(4)
      end
    end
  end
end
