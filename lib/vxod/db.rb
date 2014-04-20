module Vxod
  module Db
    class << self
      def openid
        unless @openid
          require 'vxod/db/mongoid'
          @openid = Vxod::Db::Default::Openid
        end

        @openid
      end

      def openid=(openid)
        @openid = openid
      end

      def user
        unless @user
          require 'vxod/db/mongoid'
          @user = Vxod::Db::Default::User
        end

        @user
      end

      def user=(user)
        @user = user
      end
    end
  end
end