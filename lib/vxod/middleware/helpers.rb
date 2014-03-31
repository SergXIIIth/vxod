require 'sinatra/assetpack'
require 'coffee_script'

module Vxod
  module MiddlewareHelpers
    def vxod
      @vxod ||= Vxod.api(self)
    end
  end
end