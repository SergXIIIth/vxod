require 'sinatra/assetpack'
require 'coffee_script'

module Vxod
  module MiddlewareHelpers
    def vxod
      @vxod ||= Vxod.api(self)
    end

    def call_vxod_api(function, if_invalid_view)
      user = vxod.send(function)
      unless user.valid?
        slim if_invalid_view, locals: { user: user }
      end
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