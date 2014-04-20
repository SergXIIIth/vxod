require 'mongoid'

module Vxod::Db::Default
  class User
    include Vxod::Db::Mongoid::User
  end
end