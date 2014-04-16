module Vxod
  class Error
    def initialize(error = nil)
      @error = error
    end

    attr_accessor :error
    attr_accessor :success

    def success?
      error.nil?
    end
  end
end