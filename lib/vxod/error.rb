module Vxod
  class Error
    def initialize(error = nil)
      @error = error
    end

    attr_accessor :error

    def success
      error.nil?
    end
  end
end