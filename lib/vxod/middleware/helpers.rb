require 'sinatra/assetpack'
require 'coffee_script'

module Vxod
  module MiddlewareHelpers
    def vxod
      @vxod ||= Vxod.api(self)
    end

    def render_view(view, model)
      slim view, locals: { model: model }
    end

    def call_vxod_api(function, invalid_view)
      model = vxod.send(function)

      if model.errors.any?
        slim invalid_view, locals: { model: model }
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