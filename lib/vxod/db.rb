module Vxod
  module Db
    class << self
      def openid
        unless @openid
          require 'vxod/db/mongoid'
          @openid = Vxod::Db::Mongoid::Openid
        end

        @openid
      end

      def openid=(openid)
        @openid = openid
      end

      def user
        unless @user
          require 'vxod/db/mongoid'
          @user = Vxod::Db::Mongoid::User
        end

        @user
      end

      def user=(user)
        @user = user
      end
    end
  end
end
