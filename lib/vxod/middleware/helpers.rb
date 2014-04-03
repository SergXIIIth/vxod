require 'sinatra/assetpack'
require 'coffee_script'

module Vxod
  module MiddlewareHelpers
    def vxod
      @vxod ||= Vxod.api(self)
    end

    def errors(model)
      if model.errors.any?
        slim :'parts/errors', locals: { model: model }
      else
        ""
      end
    end
  end
end