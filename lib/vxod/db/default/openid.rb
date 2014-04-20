require 'mongoid'

module Vxod::Db::Default
  class Openid
    include Vxod::Db::Mongoid::Openid
  end
end